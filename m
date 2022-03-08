Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0EE184D21C4
	for <lists+kvm@lfdr.de>; Tue,  8 Mar 2022 20:41:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244521AbiCHTmj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Mar 2022 14:42:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236213AbiCHTmi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Mar 2022 14:42:38 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADDA3340EF
        for <kvm@vger.kernel.org>; Tue,  8 Mar 2022 11:41:41 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id bx5so277019pjb.3
        for <kvm@vger.kernel.org>; Tue, 08 Mar 2022 11:41:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=VSDyqGnviveRTH3Wf+bUrNvV9Iy21N2m3phHscUBuWs=;
        b=cyA+UbQgHbzTcCp+o2TDE4wzOOaPcbAFv7XcK9PfDKf1HSUahkBUKOe4POQQMTcNxc
         bTUqLpL/e+wR311h4A75pOoXf5twYx1gkFeay6Yi4FmqTNHEvfRds/LRxcCHBrKYnx2Q
         Me6yCZ9lNX4BlKMq22UV0u1T4iiP9Ps1NZxpSg3qMKzUGvDrC2ODcCYZUPMQlhqCXuGz
         A3A6tX4J40KxpGZCtUgFREJV4lx91oRyxLYxJKvTcGBq79IQCBEFVRnj+fWRLg/5zRkb
         Ihf+32PmHpglIJ57eRzO200ifLPE7cGBFsnWyh6DiKUkFp3A27lSUEAwGdsQRZqX7+IT
         0ekA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=VSDyqGnviveRTH3Wf+bUrNvV9Iy21N2m3phHscUBuWs=;
        b=Y1NWT4rqNNma6Lik+3TrpVrOZ67PMK/SjBMxh0RG31XJSRrTo4SRfV133hZMJhTR0Q
         7lZqIW+1vANOgnKU8Rjs4I4HpfVjClqQAZosD1cc+X9FlbOxw75iBQyAfHQa35iuHQnd
         FqC6cak/A4hWLk3a+jPydudF5kc5RpdJ2esT+NHvYvxJ5lbVqB0rCHnAxaWwmWtTHBWZ
         d4te3CtjmCx74zOwTF469Fll0URbik2Oh3g31qxPSxhMfuN39dL7nTbpkczisKgSC4vC
         uzkqgOxHvcoShQhm5X7/Ywrk7nJET84KvVG+SdZxJHEdutfaOfJgmpVLsqrlCJBXxDTh
         jAVg==
X-Gm-Message-State: AOAM530wFKgeOVCBnN7nmZHCvJu58uYHI8RtCQe8xQ0hSlkWLcL46zNi
        /vWcy0JYb6+XXmbZLHTPUPh+Cw==
X-Google-Smtp-Source: ABdhPJwREhd7ngMoiKoylzzGHadoMHZXPOAvqTMKDqOtT+oqc/QedggAl2z0ZTXxEG5HtmybtkA9UQ==
X-Received: by 2002:a17:902:704b:b0:14d:2c86:387 with SMTP id h11-20020a170902704b00b0014d2c860387mr19265087plt.1.1646768501014;
        Tue, 08 Mar 2022 11:41:41 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id p17-20020a056a000b5100b004f70db04218sm7393220pfo.33.2022.03.08.11.41.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Mar 2022 11:41:40 -0800 (PST)
Date:   Tue, 8 Mar 2022 19:41:36 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        dmatlack@google.com
Subject: Re: [PATCH v2 19/25] KVM: x86/mmu: simplify and/or inline
 computation of shadow MMU roles
Message-ID: <YiexcHXodAIfPRD4@google.com>
References: <20220221162243.683208-1-pbonzini@redhat.com>
 <20220221162243.683208-20-pbonzini@redhat.com>
 <Yiev/V/KPd1IrLta@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yiev/V/KPd1IrLta@google.com>
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

On Tue, Mar 08, 2022, Sean Christopherson wrote:
> On Mon, Feb 21, 2022, Paolo Bonzini wrote:
> > @@ -4822,18 +4798,23 @@ static void kvm_init_shadow_mmu(struct kvm_vcpu *vcpu,
> >  {
> >  	struct kvm_mmu *context = &vcpu->arch.root_mmu;
> >  	union kvm_mmu_paging_mode cpu_mode = kvm_calc_cpu_mode(vcpu, regs);
> > -	union kvm_mmu_page_role root_role =
> > -		kvm_calc_shadow_mmu_root_page_role(vcpu, cpu_mode);
> > +	union kvm_mmu_page_role root_role;
> >  
> > -	shadow_mmu_init_context(vcpu, context, cpu_mode, root_role);
> > -}
> > +	root_role = cpu_mode.base;
> > +	root_role.level = max_t(u32, root_role.level, PT32E_ROOT_LEVEL);
> 
> Heh, we have different definitions of "simpler".   Can we split the difference
> and do?
> 
> 	/* KVM uses PAE paging whenever the guest isn't using 64-bit paging. */
> 	if (!____is_efer_lma(regs))
> 		root_role.level = PT32E_ROOT_LEVEL;

Ha, and then the very next patch stomps all over this.  I think this just needs
to add

	BUILD_MMU_ROLE_ACCESSOR(ext, efer, lma);

and do

	if (!is_efer_lma(context))
		root_role.level = PT32E_ROOT_LEVEL;
