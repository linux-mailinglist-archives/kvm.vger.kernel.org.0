Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2020743BE83
	for <lists+kvm@lfdr.de>; Wed, 27 Oct 2021 02:36:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234724AbhJ0Aie (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Oct 2021 20:38:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229585AbhJ0Aic (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Oct 2021 20:38:32 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86667C061745
        for <kvm@vger.kernel.org>; Tue, 26 Oct 2021 17:36:08 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id g184so1189545pgc.6
        for <kvm@vger.kernel.org>; Tue, 26 Oct 2021 17:36:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ANQVei0OAYPzDduqskhNDVMB99wes7Zs4ra1IvZPc+M=;
        b=ZDnRZDj7h8dLkmLIq/EOPggJSv/gxvROqDLF0aE4Q4sLvorxnkp0L6urWlSORtoOMO
         HG3iLDv/K/609AEJIzsTHCTnwJJjev1jTL3uxmCp/fT666gDhhX6UnAQLOdeKJAPNBl/
         a9TImyb4kRgBkY8G71bzwAKy5JQmbKH32sYQo/i1Pq1aUd/Ta6xtgiapyWSyfvqrTkms
         fXwZFi3eU2DThSk84ViE20rMypG7Pnu1UZT9C9fbQcpYXysFeSO8yPwSXtr02jWeO/aU
         sm37XvH160u4chOl7/5azYtvRbsCKAic8uvCSRcPooRAgc2vLaDRNZgN86uLfvNNHZUn
         CKoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ANQVei0OAYPzDduqskhNDVMB99wes7Zs4ra1IvZPc+M=;
        b=QnA1JdYYFZJVKvewvJWdQ5qLpkUd8VGNW4hh817tOSdYSVf+zhtQLvip+poxx7X2Bk
         eanF3V7/LhEX3HZJSHEo/uiClNltB4SusmPpwd6S7IoOvDFdxJBCB++xLHN23CWQ4rX8
         GOmbD61iW/PXILuQdaK5wp3e8UR3qD2EUE97/h3xQPFmPO2ymSx889nGN+6DO9VS6hFG
         dwjaxelo/yznfvdfHJSSMZCJsB0p2SMX9wTroP6pUePL9ZCjokC1hQTEEuX6opkPpao3
         NuLB5QfTmrppnPw+f0cs1suE0WsJHmz8Wv60pij+ee64V4UPPqk0ncVW7M7RNxYuVswC
         Mhvg==
X-Gm-Message-State: AOAM532jsg8DBO9JnX863DcApx3xjDfXNYqdS0heZuKBXOiLeHmRNu1W
        cxE7eaLLUKYrvzYYb2txL/xpsA==
X-Google-Smtp-Source: ABdhPJwX6XrzSFLQzZRXGz7ZiHxTjoMfiMZwR5c20YZbmpMEzEWrJ6TRK2XdryexJ9ATXxwA/a2+gw==
X-Received: by 2002:a63:920b:: with SMTP id o11mr21399431pgd.314.1635294967878;
        Tue, 26 Oct 2021 17:36:07 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id z7sm19913267pgo.11.2021.10.26.17.36.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Oct 2021 17:36:07 -0700 (PDT)
Date:   Wed, 27 Oct 2021 00:36:03 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Igor Mammedov <imammedo@redhat.com>,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 11/13] KVM: Keep memslots in tree-based structures
 instead of array-based ones
Message-ID: <YXie8z7w4AiFx4bP@google.com>
References: <cover.1632171478.git.maciej.szmigiero@oracle.com>
 <0c35c60b524dd264cc6abb6a48bc253958f99673.1632171479.git.maciej.szmigiero@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0c35c60b524dd264cc6abb6a48bc253958f99673.1632171479.git.maciej.szmigiero@oracle.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 20, 2021, Maciej S. Szmigiero wrote:
> @@ -1607,68 +1506,145 @@ static int kvm_set_memslot(struct kvm *kvm,
> +	if (change != KVM_MR_CREATE) {
>  		/*
> -		 * The arch-specific fields of the memslots could have changed
> -		 * between releasing the slots_arch_lock in
> -		 * install_new_memslots and here, so get a fresh copy of these
> -		 * fields.
> +		 * The arch-specific fields of the memslot could have changed
> +		 * between reading them and taking slots_arch_lock in one of two
> +		 * places above.
> +		 * That includes old and new which were read in __kvm_set_memory_region.
>  		 */
> -		kvm_copy_memslots_arch(slots, __kvm_memslots(kvm, as_id));
> +		old->arch = new->arch = slotina->arch = slotact->arch;

Fudge.  This subtly and silently fixes an existing bug where @old and @new can
have stale arch specific data due to x86's godawful slots_arch_lock behavior.
If a flags-only update collides with alloc_all_memslots_rmaps(), @old and @new
may have stale (NULL) data if the rmaps activation happens after the old slot is
snapshotted.

It can be fixed by doing exactly this, but that is so, so gross (not your fault
at all, I'm complaining about the existing mess).

I think we can opportunistically prep for this series to make the end result
(mostly this patch), a bit cleaner while fixing that snafu.  Specifically, I
think I see a path to avoiding bikeshedding slotina, slotact, etc...

I'll get a series for the fix posted tomorrow, and hopefully reply with my thoughts
for this patch too.
