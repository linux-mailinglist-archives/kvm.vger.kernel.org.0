Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3E605BECF6
	for <lists+kvm@lfdr.de>; Tue, 20 Sep 2022 20:46:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230142AbiITSqf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Sep 2022 14:46:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229499AbiITSqe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Sep 2022 14:46:34 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42EAB719AD
        for <kvm@vger.kernel.org>; Tue, 20 Sep 2022 11:46:33 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id u132so3576142pfc.6
        for <kvm@vger.kernel.org>; Tue, 20 Sep 2022 11:46:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=96kGAEFwpIsS8k7Zh8wIdbm4cyHnojtfpuI7IJsWAcI=;
        b=riZjjfX6wpM8dgyx8h+OjFOVA8RkxuCIxJ9pTi7khDvWPa/mhAnoPAzRADe+aCGvnL
         /dm7v7ElsO+NiVjYsFVxyFTUN5GmKmM5q0qDd+RTjx0lYtyYZIKNmNMhrnyoyIytK5/X
         sLGn8hkUkHcMmE+Ra7jsnF4Vk42ZWrKN9aPIzRPR1UxxVKtSzne5bP8+ccBQk9LLukiM
         WmOK+ob09mztftwpBFQVoF1oZvhtaMBL1HrzSt7ZNCRn1jN8OOilmrK8LVb0GjHlcpfe
         yBspxI1uSrnZ/yfolZFIQ8ldhpEZS1zydKPGpuD3zPA9TIkdepClyLOcDhGBG2RFUgdt
         qo9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=96kGAEFwpIsS8k7Zh8wIdbm4cyHnojtfpuI7IJsWAcI=;
        b=Rr5xXTVjZuOu6LQRE5Wvkk74hXWl39ukIJgahnUofu5WlZ7tKjfjX4qxsLYJhSo4IM
         c0Zn5xgD8P1Aa9NFK7Vp8xwj8N9pMJxxV+DR/b14PhL/bjoWQd/PKm9ccyBNrmIW9Ono
         GqpqDjzR+0NdleJ509OPC9+HMeYVf3KwUP/5dbvXjPWXtoeRXhAIKJ6PVrUOqoSF9eUC
         Bq0lUKBv9sQ5+GMYVp8ZHU3gL9zl6nzwf4clI/UMoo3hWUvGPkHUpPwguqgVxARkHtwE
         VdYaaxBB/03CWei4Rj3leNH46EsVZUG26jolp/pWXTgKeX0An4a3EXkO2JriE0xr0MlX
         VoUA==
X-Gm-Message-State: ACrzQf1icu3PJtDqPibJc3DMEE8BWM8c1CZnJBIxIJNPDpIFedyCE268
        DPXaOwTtncf77sccftmuLYI9sA==
X-Google-Smtp-Source: AMsMyM6uNLxs0jQvXvT1d2FkG+voWOEWDh7r5Lp+7cufyp9pNbXAjyeg0rDB5YGEc84tQUeW+KglnA==
X-Received: by 2002:a05:6a00:15d4:b0:544:170c:4f5a with SMTP id o20-20020a056a0015d400b00544170c4f5amr25381163pfu.75.1663699592648;
        Tue, 20 Sep 2022 11:46:32 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id z16-20020aa79e50000000b0053dea60f3c8sm239327pfq.87.2022.09.20.11.46.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Sep 2022 11:46:32 -0700 (PDT)
Date:   Tue, 20 Sep 2022 18:46:28 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Oliver Upton <oliver.upton@linux.dev>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Andrew Jones <andrew.jones@linux.dev>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Subject: Re: [PATCH 4/5] KVM: selftests: Explicitly verify KVM doesn't patch
 hypercall if quirk==off
Message-ID: <YyoKhKPf6Bv4X56B@google.com>
References: <20220908233134.3523339-1-seanjc@google.com>
 <20220908233134.3523339-5-seanjc@google.com>
 <Yyjd7pcBw0NkYVQE@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yyjd7pcBw0NkYVQE@google.com>
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

On Mon, Sep 19, 2022, Oliver Upton wrote:
> On Thu, Sep 08, 2022 at 11:31:33PM +0000, Sean Christopherson wrote:
> > @@ -75,12 +76,28 @@ static void guest_main(void)
> >  	}
> >  
> >  	/*
> > -	 * The hypercall didn't #UD (guest_ud_handler() signals "done" if a #UD
> > -	 * occurs).  Verify that a #UD is NOT expected and that KVM patched in
> > -	 * the native hypercall.
> > +	 * If the quirk is disabled, verify that guest_ud_handler() "returned"
> > +	 * -EFAULT and that KVM did NOT patch the hypercall.  If the quirk is
> > +	 * enabled, verify that the hypercall succeeded and that KVM patched in
> > +	 * the "right" hypercall.
> >  	 */
> > -	GUEST_ASSERT(!ud_expected);
> > -	GUEST_ASSERT(!memcmp(native_hypercall_insn, hypercall_insn, HYPERCALL_INSN_SIZE));
> > +	if (ud_expected) {
> > +		GUEST_ASSERT(ret == (uint64_t)-EFAULT);
> > +
> > +		/*
> > +		 * Divergence should occur only on the last byte, as the VMCALL
> > +		 * (0F 01 C1) and VMMCALL (0F 01 D9) share the first two bytes.
> > +		 */
> > +		GUEST_ASSERT(!memcmp(native_hypercall_insn, hypercall_insn,
> > +				     HYPERCALL_INSN_SIZE - 1));
> > +		GUEST_ASSERT(memcmp(native_hypercall_insn, hypercall_insn,
> > +				    HYPERCALL_INSN_SIZE));
> 
> Should we just keep the assertions consistent for both cases (patched
> and unpatched)?

Not sure I follow what you're suggesting.  By "consistent" do you mean doing
something like snapshotting hypercall_insn and verifying that it's not changed?
