Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7B00535389
	for <lists+kvm@lfdr.de>; Thu, 26 May 2022 20:46:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243848AbiEZSqG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 May 2022 14:46:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348944AbiEZSp5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 May 2022 14:45:57 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8BEC12E089
        for <kvm@vger.kernel.org>; Thu, 26 May 2022 11:45:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653590755;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ODmk396yYTmyZ0DEUNSD4vk11H4s6Zx2e3M7LfpgTu0=;
        b=cfXUWbAcXgoxMZR7qya5+a2trFIMbFtlEcdEctvM35x2zFxCTzyTXCCOZIfILhLR0mBH6R
        QEeeNMd86Bm16zae7zCuR7xDj8StPKP6kNyl8GWdx1rYfM2QKhXoKJFKt3TMpVLkvDTXu2
        0E6DpZumCFeK3Ir/j5hMcWnG7aCo5hI=
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com
 [209.85.166.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-184-22nIMBaKP7G9DnCuUFD8Yw-1; Thu, 26 May 2022 14:45:51 -0400
X-MC-Unique: 22nIMBaKP7G9DnCuUFD8Yw-1
Received: by mail-io1-f71.google.com with SMTP id y12-20020a5e920c000000b006657a63c653so1501422iop.11
        for <kvm@vger.kernel.org>; Thu, 26 May 2022 11:45:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ODmk396yYTmyZ0DEUNSD4vk11H4s6Zx2e3M7LfpgTu0=;
        b=M5LroYTaFYhaVx0AuCx2gB5SKZGuHd1nymjBL+N4yz2k0xl7EYG9aKwRDeMMM8EPLo
         CbJ3aCIgtHfEC9KwWu+01sbzQVOFkqblzPp9iwPwBrKbq2u/5Z1J0ZSz9Oo0KnHemTg/
         mTD8TDZuua3SABKg28yi/T9wSt153vMGmmt7Ny6OaIv0cJhd9xq3v8xkkawBNFSMPQUV
         TKoXGUBH5B9dZP5guMINcD8A12l1dX+beHCaBBTMp8CPXXURsbJN9fmjdDN29aB/Z3ja
         lEpfpfLX+5j9kuj5+/7yZDh7uP1yAshGj3K7Kc76MZCEcsK/XmkiBm+F9DDcstDkARCI
         VOeg==
X-Gm-Message-State: AOAM533YiseUkAOGdpuze4CS2ClgNZSsBhwGi04mi8+wyKl/KJyLW2Kj
        K2HTp5d4BIcibrQi8xm12gmt3Y0wnYEaCb5a+x5Nz0Y/cK+2Dyftu3fgVRKBY6oyhOYWqaVQH41
        V+P/IopnAndZO
X-Received: by 2002:a05:6638:1482:b0:32e:bd66:9191 with SMTP id j2-20020a056638148200b0032ebd669191mr12341641jak.134.1653590751031;
        Thu, 26 May 2022 11:45:51 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxh6amKbzzvb1F7KtA6vAjHtNku/3C9o4ZBn9vc2jMF1RWid75p2srSYyvZUrM76JTgJ+owew==
X-Received: by 2002:a05:6638:1482:b0:32e:bd66:9191 with SMTP id j2-20020a056638148200b0032ebd669191mr12341638jak.134.1653590750841;
        Thu, 26 May 2022 11:45:50 -0700 (PDT)
Received: from xz-m1.local (cpec09435e3e0ee-cmc09435e3e0ec.cpe.net.cable.rogers.com. [99.241.198.116])
        by smtp.gmail.com with ESMTPSA id o27-20020a02cc3b000000b0032e49fcc241sm568150jap.176.2022.05.26.11.45.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 May 2022 11:45:50 -0700 (PDT)
Date:   Thu, 26 May 2022 14:45:48 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Ben Gardon <bgardon@google.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        linux-kernel@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>,
        David Matlack <dmatlack@google.com>,
        Jim Mattson <jmattson@google.com>,
        David Dunn <daviddunn@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Junaid Shahid <junaids@google.com>
Subject: Re: [PATCH v8 11/11] KVM: selftests: Cache binary stats metadata for
 duration of test
Message-ID: <Yo/K3L62VUh4vW30@xz-m1.local>
References: <20220526175408.399718-1-bgardon@google.com>
 <20220526175408.399718-12-bgardon@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220526175408.399718-12-bgardon@google.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 26, 2022 at 05:54:08PM +0000, Ben Gardon wrote:
> In order to improve performance across multiple reads of VM stats, cache
> the stats metadata in the VM struct.
> 
> Signed-off-by: Ben Gardon <bgardon@google.com>

Reviewed-by: Peter Xu <peterx@redhat.com>

-- 
Peter Xu

