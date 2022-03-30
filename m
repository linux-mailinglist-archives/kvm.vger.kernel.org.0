Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E26FF4ECE80
	for <lists+kvm@lfdr.de>; Wed, 30 Mar 2022 23:06:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351090AbiC3Uon (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Mar 2022 16:44:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232155AbiC3Uom (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Mar 2022 16:44:42 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F982443D5
        for <kvm@vger.kernel.org>; Wed, 30 Mar 2022 13:42:57 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id g9-20020a17090ace8900b001c7cce3c0aeso821280pju.2
        for <kvm@vger.kernel.org>; Wed, 30 Mar 2022 13:42:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=G2Eo6r97owDtczFfVpJgXwuwxzvJje+iY5MUwcbp6hw=;
        b=ZyVdrFUSHODjAn6lXuymsg1JdqIUb6/sjDeEVqnj8cdu+O4oEfaI7fgVObXyWbl0gz
         HmiqDpTQiUePxaehF25QdacbwMcQ2C5KxkCoX+CptKY7WzMaFdEwdDnGHLq4NlmVhgqT
         aNF9pxUjNnz7RpHHm/3pz187Q5TnIWJJLg/SeanGydlc4aOHohQy8VUAgQK6AYF0w4xw
         /V4ZhjaE46mj+17Aq/Q6HXbV7HsFqo4Pq99AilRX1iHDtHL6kyBrbsg7YJFvgZ93I+da
         E+b0lWq3jcosPIyWLPnOF0gkXl3wnyJsK07zMBfljy0RGM9rQ0poX38AWEV/VM7/orBq
         yafA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=G2Eo6r97owDtczFfVpJgXwuwxzvJje+iY5MUwcbp6hw=;
        b=Xxatx033r/E48Vo5mje8g6Qhad+OE4Oah9nZA43LSE3+CDSicLBnmjzyONndCgY31X
         xeiywAY8J9ZgSU4sP/H9MuRRj+7CDhbhQRQUo5wy2WAgYKp9gb7E7YSjpTd2UPhaWnpL
         0xsSrdeL7rbL2+eqni6DR/Iitc5DXK8PxxtWIhx2RQeKB8qMFom9QdH5KafnVNFNIKoX
         c2sWfhep8HWNqwHX2g8eN0Di/pnFLNq0cTInlntiAStKqQf4TkeTCBSNIsP8iB9gY2EG
         JRMJwPzwNJgNJWLg/yZerHBV0ft1jChRigsYNwBRCWEzwbY9aPTHELnwfVI8CaSFRBUE
         5inQ==
X-Gm-Message-State: AOAM531BjU8OUkBJ5yTLVpHPikd/LP3aDBzGFdNPbEdNd+2mrxfpkljF
        y74A325ANAm/kAlyrJNPOMM8gA==
X-Google-Smtp-Source: ABdhPJw6fEr/GwKy79RI7/WOYqE6MiaV+tYZtpjRtJ/Sx57E224WYrZLwj+uQttCNkOgyUQdLhgNvw==
X-Received: by 2002:a17:90b:4c41:b0:1c7:3fa8:9b6a with SMTP id np1-20020a17090b4c4100b001c73fa89b6amr1660523pjb.120.1648672976582;
        Wed, 30 Mar 2022 13:42:56 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id a11-20020a056a000c8b00b004fade889fb3sm26069455pfv.18.2022.03.30.13.42.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Mar 2022 13:42:55 -0700 (PDT)
Date:   Wed, 30 Mar 2022 20:42:52 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Chenyi Qiang <chenyi.qiang@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Xiaoyao Li <xiaoyao.li@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 2/7] KVM: VMX: Add proper cache tracking for PKRS
Message-ID: <YkTAzCPZ3zXYDBLj@google.com>
References: <20220221080840.7369-1-chenyi.qiang@intel.com>
 <20220221080840.7369-3-chenyi.qiang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220221080840.7369-3-chenyi.qiang@intel.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Feb 21, 2022, Chenyi Qiang wrote:
> Add PKRS caching into the standard register caching mechanism in order
> to take advantage of the availability checks provided by regs_avail.
> 
> This is because vcpu->arch.pkrs will be rarely acceesed by KVM, only in
> the case of host userspace MSR reads and GVA->GPA translation in
> following patches. It is unnecessary to keep it up-to-date at all times.

It might be worth throwing in a blurb that the potential benefits of this caching
are tenous.

Barring userspace wierdness, the MSR read is not a hot path.

permission_fault() is slightly more common, but I would be surprised if caching
actually provides meaningful performance benefit.  The PKRS checks are done only
once per virtual access, i.e. only on the final translation, so the cache will get
a hit if and only if there are multiple translations in a single round of emulation,
where a "round of emulation" ends upon entry to the guest.  With unrestricted
guest, i.e. for all intents and purposes every VM using PKRS, there aren't _that_
many scenarios where KVM will (a) emulate in the first place and (b) emulate enough
accesses for the caching to be meaningful.

That said, this is basically "free", so I've no objection to adding it.  But I do
think it's worth documenting that it's nice-to-have so that we don't hesitate to
rip it out in the future if there's a strong reason to drop the caching.

> Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
> ---

Reviewed-by: Sean Christopherson <seanjc@google.com>
