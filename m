Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7DA65EE9C4
	for <lists+kvm@lfdr.de>; Thu, 29 Sep 2022 00:55:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234611AbiI1WzV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Sep 2022 18:55:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234661AbiI1WzO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Sep 2022 18:55:14 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5186E57BFE
        for <kvm@vger.kernel.org>; Wed, 28 Sep 2022 15:55:13 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id u69so13521722pgd.2
        for <kvm@vger.kernel.org>; Wed, 28 Sep 2022 15:55:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=kEow7JtyXZKSoXCpvGfzKSDblkL9Mmtib8QujjWXNoU=;
        b=W5NJliA1lAIbdRt7RjgOqkzCloKRkvJxy0UkoFRSnvKxKTTjHI/mF1w/D3VVBfQSwy
         eiJ7iqnAlItjuRkOwrgpmkBVYs54d4kv+ivKNLpdmNRGhYOb9hPgD64smE6NdDtndW9a
         gl1oy3Amv0tOaAuRoJNEZuIddPAdMU2UGGA8Uzyw9eE6zYbCJ7Me/84n723upsochOj0
         Xnnimebv1CwpXUycLesPsAENzIF98SfnfffSheJoWb6cFjeiCY52qHlZZZsUW+F/8eCB
         9LES6msPeE+vjct0OcqRIeEYFsw2PBXdgKN42BYMPa3Yrvord4L1hTOzWm3wQ7leEuUq
         Wo6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=kEow7JtyXZKSoXCpvGfzKSDblkL9Mmtib8QujjWXNoU=;
        b=ooeshHMZoHoHFsRKevaKpw0WmcxQbUrYg8pqGIe7W6H4pkkWhaWvqGY5nWs12/3/rD
         SLfTIVrSMMNInjwRDcp0jQgCaB6M+WZzwZptaIj5KrrP9VIzeqioLgyT5zFs0bgF3+k5
         IsWuB90FnOO/gHAZ9uAfajPg94ULRkGOtBj7bAbfvYzkvU4UF6FHW+CH4D5SiLEXlrc8
         XqafNKMib9gGxow7F8kLrEygZNqDo+wiq7FE6vb4gFlgSKsY3NElvnFe0UOYHpCRvFOt
         y8gY+uoZyWfZAjvS03f2+5Zmt/vKYoTIGcx6lk6CCWnImSQrbKXAKLPlkFLgM+yODUL6
         1FAg==
X-Gm-Message-State: ACrzQf0zA48MB2aQ80qZ/6THt8uwlAVnjSCTDQl4/Yp7pKoI7ZVab3C0
        EjV4Nm18pUJVjNiA/ZsIFVzgeg==
X-Google-Smtp-Source: AMsMyM5oZsrbpWYgy5zanmRt7Yiut9T7BF7N9dL6fKosXpCx8wgGERFXZ8EeJ4TVMrjaBZ56LsKuDA==
X-Received: by 2002:a63:1203:0:b0:43c:7fa:f306 with SMTP id h3-20020a631203000000b0043c07faf306mr103725pgl.169.1664405712691;
        Wed, 28 Sep 2022 15:55:12 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id t11-20020a170902e84b00b0016d1b70872asm4332278plg.134.2022.09.28.15.55.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Sep 2022 15:55:12 -0700 (PDT)
Date:   Wed, 28 Sep 2022 22:55:08 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     David Matlack <dmatlack@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Ben Gardon <bgardon@google.com>,
        Jim Mattson <jmattson@google.com>,
        Peter Xu <peterx@redhat.com>,
        Yang Zhong <yang.zhong@intel.com>,
        Wei Wang <wei.w.wang@intel.com>, kvm@vger.kernel.org
Subject: Re: [PATCH v2 3/3] KVM: selftests: Fix nx_huge_pages_test on
 TDP-disabled hosts
Message-ID: <YzTQzHf4X6hq+wyQ@google.com>
References: <20220928184853.1681781-1-dmatlack@google.com>
 <20220928184853.1681781-4-dmatlack@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220928184853.1681781-4-dmatlack@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 28, 2022, David Matlack wrote:
> diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
> index 0cbc71b7af50..3082c2a4089b 100644
> --- a/tools/testing/selftests/kvm/include/x86_64/processor.h
> +++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
> @@ -825,6 +825,8 @@ static inline uint8_t wrmsr_safe(uint32_t msr, uint64_t val)
>  	return kvm_asm_safe("wrmsr", "a"(val & -1u), "d"(val >> 32), "c"(msr));
>  }
>  
> +bool kvm_tdp_enabled(void);

Uber nit, maybe kvm_is_tdp_enabled()?
