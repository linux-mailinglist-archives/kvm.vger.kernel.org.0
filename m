Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 165F560EB0C
	for <lists+kvm@lfdr.de>; Wed, 26 Oct 2022 23:57:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233673AbiJZV5m (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Oct 2022 17:57:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233701AbiJZV5f (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Oct 2022 17:57:35 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EE84F41BD
        for <kvm@vger.kernel.org>; Wed, 26 Oct 2022 14:57:27 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id f193so16377374pgc.0
        for <kvm@vger.kernel.org>; Wed, 26 Oct 2022 14:57:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=yBCqQl7C95Ae609/pKLQsFkiyQPPBReFiNcdK7bH4Gs=;
        b=BXULZMO54vlQmWlTrlAqUQPxVI28yZu/zUlJZ+d6dQecwjkpAs8nKBcHe2eV3051y5
         DuifxTkBZm/NLh70EEZBv+vlGL9i/VHaqoGUt63ywP3X2I+De9SUo8SfUYFhBdiywJob
         Y1JGy8J2cABrMNQ4ZRJyAa0p/UfQs260GuP4KYlyj0PLdLwbLbvbUHWZcldhhc/A0fQr
         0IEc7tiuC4zaFFEQyNB3FlNE4fiVAKsjn0QC2Ah68CVtAtrrZ4S2SMXw211rGY/yKJUE
         Vmj7JjyzG1E/hnwv+rpBx4tJwqajsrH/sgg9WFzEjRnfBlF8BoMLE2TBslcH/oVr8wf/
         WLPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yBCqQl7C95Ae609/pKLQsFkiyQPPBReFiNcdK7bH4Gs=;
        b=zaaoTf0O6Wwhm1NlND6s8vuopSqMfe/PXXt32tuL+xaynDXEfnbGtaCncVs4Qt4usx
         jMt1mdiXW0unTSH9UknzIf9+rJQOKkPZ4MLBLUEmHv8qH2lWqzPgrdYyU4Mcp9yQqKZw
         SxRn/ZvoG+KiysXXt1UQ8aX9jd/gwrXT7COieqxmvrKLhp0R8Xj7VI4vMd1TJGd91TSG
         i5y8PobK6CifoPMqsBJn3DK4iP9ilyz2VUs7kemmR0U9dA3lYnZngFf3FUjJT/6OGpDq
         ammgMMLKJwI07OdZeiUN5RusvgZicwtGLHFNQL3nDL3cP1dTjZ87KL9BkdGa7FZsgZHU
         Cl1g==
X-Gm-Message-State: ACrzQf1RcXpLxetfViFX7oGaDN8G6r3Rui1nf0/KbnUDAf5o83B8FPlm
        yeF4VnIJE+yitXYbXr+mdAnDWk1/d103Bg==
X-Google-Smtp-Source: AMsMyM6EZ5sH/GDkOk4kvDNrmXrcm6xvFxNi3qJDwSKxyp3sFIo4IjKKB+ChUJ/BIfBdJeEeiHHDlQ==
X-Received: by 2002:a62:7b0f:0:b0:56b:e472:9e81 with SMTP id w15-20020a627b0f000000b0056be4729e81mr16296269pfc.13.1666821446468;
        Wed, 26 Oct 2022 14:57:26 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id i12-20020a63220c000000b0046270ad651bsm3179016pgi.94.2022.10.26.14.57.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Oct 2022 14:57:26 -0700 (PDT)
Date:   Wed, 26 Oct 2022 21:57:22 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        Yuan Yao <yuan.yao@linux.intel.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v12 34/46] KVM: selftests: Fill in vm->vpages_mapped
 bitmap in virt_map() too
Message-ID: <Y1mtQkW6mcduQqNP@google.com>
References: <20221021153521.1216911-1-vkuznets@redhat.com>
 <20221021153521.1216911-35-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221021153521.1216911-35-vkuznets@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Oct 21, 2022, Vitaly Kuznetsov wrote:
> Similar to vm_vaddr_alloc(), virt_map() needs to reflect the mapping
> in vm->vpages_mapped.
> 
> While on it, remove unneeded code wraping in vm_vaddr_alloc().

"wrapping", this is dangerously close to getting someone fired ;-)
