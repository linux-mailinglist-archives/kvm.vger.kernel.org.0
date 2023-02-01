Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 641F1685C41
	for <lists+kvm@lfdr.de>; Wed,  1 Feb 2023 01:39:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231755AbjBAAjO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Jan 2023 19:39:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230204AbjBAAjN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 Jan 2023 19:39:13 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B04D273B
        for <kvm@vger.kernel.org>; Tue, 31 Jan 2023 16:39:12 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id z1so9315986plg.6
        for <kvm@vger.kernel.org>; Tue, 31 Jan 2023 16:39:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=F0GdAR0v2Ntap0HJ2NsIfGxXKqahI5FZuPXOS/K2KC8=;
        b=jfZouOb9QzsPA9F1x1KNbo/JJtUMImiTs/0XZ1IPXMdH380nQVF2mgqAIZvHfKYw69
         eBzKoDBa3k7olWv/obXmKpC8jiInJkB6UEPnSVwYyt4P+/jjtaij9YsulaZSm8OaxJxn
         obOxPykXNicw+0EtKRbilD8jCywvc2GJCg+vP2eUbIDXSZyHhjrJGwH93lwM/gM19anY
         35AKuGMKKVdVPLsM4VQETEIxclTiEdawM7a3QsZkfdmFjQyetK4X+fLNyza0RrJJj2Sy
         izFzg6rBa1WsXQ94YpQuATpO5nRXIoHcdZwfTZYF2h2KaHh42iIE4fWL2amQommsSSGy
         HzMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=F0GdAR0v2Ntap0HJ2NsIfGxXKqahI5FZuPXOS/K2KC8=;
        b=fux2oO7OjWlZ+Fp9KOzfOzdVvnKuxWy0BMT2seVAVhi57CcQDdmwttsKxIfqrtsIVK
         QBG4gMa4FCuHoCBv7kgG+qBQrPKaXx2m6RhKl399U+rzxEhIV0te7btehrDBzrxffmNc
         SsngrnOywylTDyq6Rxeuf+c+kIJ/PY/ckeW2nNjZDMAe1LeGdR0wWp3zAH3gr3TdIRMw
         MJtOz8ww8phcTJxyjlv46XGRjYyA/fGjKHQ8d+3DkEJd1XZznW0lxrg0XQeyJKIBO3oF
         4qY9NfkKjdCj/JPLkMjRrfDnUtc0lUFK70ziBlv52w4+5Tb97RO9SdypSaUcTGLPuO7v
         a1mA==
X-Gm-Message-State: AO0yUKWGJArRKQAqYRRmk55WH6FVerWRhHUzpL4VAqBSi94XbvMe7mTn
        KSu9JABry0McjYi5beHtzEOJpw==
X-Google-Smtp-Source: AK7set8ZASSGw1z1PfZ59ELQwPnBtuiLKg0zGfgCijzGy0WTF3y5sge/CYZ3szc/5gs8AK7VwYGNKw==
X-Received: by 2002:a17:902:7882:b0:198:af50:e4e9 with SMTP id q2-20020a170902788200b00198af50e4e9mr2680pll.15.1675211951629;
        Tue, 31 Jan 2023 16:39:11 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id f190-20020a636ac7000000b004a737a6e62fsm8933232pgc.14.2023.01.31.16.39.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Jan 2023 16:39:11 -0800 (PST)
Date:   Wed, 1 Feb 2023 00:39:07 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     kvm@vger.kernel.org, Sandipan Das <sandipan.das@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Borislav Petkov <bp@alien8.de>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Daniel Sneddon <daniel.sneddon@linux.intel.com>,
        Jiaxi Chen <jiaxi.chen@linux.intel.com>,
        Babu Moger <babu.moger@amd.com>, linux-kernel@vger.kernel.org,
        Jing Liu <jing2.liu@intel.com>,
        Wyes Karny <wyes.karny@amd.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Santosh Shukla <santosh.shukla@amd.com>
Subject: Re: [PATCH v2 10/11] KVM: SVM: implement support for vNMI
Message-ID: <Y9m0q31NBmsnhVGD@google.com>
References: <20221129193717.513824-1-mlevitsk@redhat.com>
 <20221129193717.513824-11-mlevitsk@redhat.com>
 <Y9mwz/G6+G8NSX3+@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y9mwz/G6+G8NSX3+@google.com>
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

On Wed, Feb 01, 2023, Sean Christopherson wrote:
> On Tue, Nov 29, 2022, Maxim Levitsky wrote:
> > @@ -553,6 +554,15 @@ static inline bool is_x2apic_msrpm_offset(u32 offset)
> >  	       (msr < (APIC_BASE_MSR + 0x100));
> >  }
> >  
> > +static inline bool is_vnmi_enabled(struct vcpu_svm *svm)
> > +{
> > +	/* L1's vNMI is inhibited while nested guest is running */
> > +	if (is_guest_mode(&svm->vcpu))
> 
> I would rather check the current VMCB.  I don't see any value in hardcoding the
> "KVM doesn't support vNMI in L2" in multiple places.  And I find the above comment
> about "L1's vNMI is inhibited" confusing.  vNMI isn't inhibited/blocked, KVM just
> doesn't utilize vNMI while L2 is active (IIUC, as proposed).

Oof.  Scratch that, code is correct as proposed, but the comment and function name
are confusing.

After looking at the nested support, is_vnmi_enabled() actually means "is vNMI
currently enabled _for L1_".  And it has less to do with vNMI being "inhibited" and
everything to do with KVM choosing not to utilize vNMI for L1 while running L2.

"inhibited" in quotes because "inhibited" is a synonym of "blocked", i.e. I read
that as L1 NMIs are blocked.

So regardless of whether or not KVM decides to utilize vNMI for L2 if L1's NMIs
are passed through, the function name needs to clarify that it's referring to
L1.  E.g. is_vnmi_enabled_for_l1() or so.

And if KVM decides not to use vNMI for L1 while running L2, state that more
explicitly instead of saying it's inhibited.

And if KVM does decide to use vNMI while running L2 if NMIs are passed through,
then the comment goes away and KVM toggles the flag in vmcb01 on nested enter
and exit.

> > +		return false;
> > +
> > +	return !!(svm->vmcb01.ptr->control.int_ctl & V_NMI_ENABLE);
> > +}
> > +
> >  /* svm.c */
> >  #define MSR_INVALID				0xffffffffU
> >  
> > -- 
> > 2.26.3
> > 
