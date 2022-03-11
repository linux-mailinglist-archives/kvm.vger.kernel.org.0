Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8666B4D5987
	for <lists+kvm@lfdr.de>; Fri, 11 Mar 2022 05:27:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346278AbiCKE2G (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Mar 2022 23:28:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233230AbiCKE2F (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Mar 2022 23:28:05 -0500
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 050521A41D1
        for <kvm@vger.kernel.org>; Thu, 10 Mar 2022 20:27:03 -0800 (PST)
Received: by mail-pf1-x430.google.com with SMTP id h2so2921428pfh.6
        for <kvm@vger.kernel.org>; Thu, 10 Mar 2022 20:27:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=VuuZr/4c1UPKQEo4uOczu6/ksfM6S6wo/JNy4TAGNVk=;
        b=UcivEOlB+uVR0KkOqADnu9jEIZf4COjV9eay8wpm68/HcpbolfpyHGoOTT+ewk5G63
         zLfqdJpJAywpEkrHOvUIk/gP5eJt3cQS7NN5TcL1ILU4x65mqrubJRoH9+UDkywx71uG
         SrPeV/+GEosd4nBp4fTXkcxxyYv6ZvoPVeCJkyfBCZS4nBo5vp2K1FdhXWaTc/wUO0QR
         RNOSOTsqOA4SfSIxyO1V6rm002CgzoKASkmCKnQrlVGrVX/qDg2wERh+UGQsk9nzNtV1
         n0FrDrp1JiRJpRR2gldDJJwNyFT423bwuU8Nl9ln/XqIBRiT+wM78qwglefvT5VT+B/S
         hqgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=VuuZr/4c1UPKQEo4uOczu6/ksfM6S6wo/JNy4TAGNVk=;
        b=k7gEadYTYc8/D13/LuhVghQ7gf0OeQ391vN4sQkByawDigyH2ai0nKHbeNF0mIUOla
         TbccZ4/LrII1Im7Sy8Yo0A4W5C5G7W5qANBnzx4CbNtUkYAGQDStqlItIzpGNs4yM/AV
         ZF1XTY9dYZsCM/e7Pv/jJeO9Jo0liUjCFKNsEcz8gN7PtB/BO84IJ7ojhoWwhF9Qqlqc
         vtCFZVNmH/4ZjCEAfoNz10C50F/LAP7pZkROlggCTl9VU9MRxCmHnXDzHLuE1jdXeRgP
         HMmDq66nC0ddPNcp0NG9PI1TdJLSif2i7NDVm6reOGuaSdZ19Wz7mkqadcTQbTzQ1Pwo
         +Wrg==
X-Gm-Message-State: AOAM532mCDTXSJZ4sWf35h8gtxOu5wSj//LKpUqN5GaHO8VoYLVUIDOH
        88mR+ji7u86TzyoZ/34ydl4Svw==
X-Google-Smtp-Source: ABdhPJx5FpRKFn9VUkyyxuCm50rwhdULgerp/xvxMqeqGB1onNa8UkHlH3VDkc/rbdpOJ+WAC4mRhg==
X-Received: by 2002:a62:cdcd:0:b0:4f6:f5c2:47d9 with SMTP id o196-20020a62cdcd000000b004f6f5c247d9mr8329402pfg.26.1646972822270;
        Thu, 10 Mar 2022 20:27:02 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id g5-20020a056a001a0500b004def10341e5sm8815641pfv.22.2022.03.10.20.27.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Mar 2022 20:27:01 -0800 (PST)
Date:   Fri, 11 Mar 2022 04:26:58 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     Chao Gao <chao.gao@intel.com>, Zeng Guang <guang.zeng@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Kim Phillips <kim.phillips@amd.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Jethro Beekman <jethro@fortanix.com>,
        Kai Huang <kai.huang@intel.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, Robert Hu <robert.hu@intel.com>
Subject: Re: [PATCH v6 6/9] KVM: x86: lapic: don't allow to change APIC ID
 unconditionally
Message-ID: <YirPkr5efyylrD0x@google.com>
References: <20220225082223.18288-1-guang.zeng@intel.com>
 <20220225082223.18288-7-guang.zeng@intel.com>
 <Yifg4bea6zYEz1BK@google.com>
 <20220309052013.GA2915@gao-cwp>
 <YihCtvDps/qJ2TOW@google.com>
 <6dc7cff15812864ed14b5c014769488d80ce7f49.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6dc7cff15812864ed14b5c014769488d80ce7f49.camel@redhat.com>
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

On Wed, Mar 09, 2022, Maxim Levitsky wrote:
> On Wed, 2022-03-09 at 06:01 +0000, Sean Christopherson wrote:
> > > Could you share the links?
> > 
> > Doh, sorry (they're both in this one).
> > 
> > https://lore.kernel.org/all/20220301135526.136554-5-mlevitsk@redhat.com
> > 
> 
> My opinion on this subject is very simple: we need to draw the line somewhere.

...

> I also understand your concerns - and I am not going to fight over this, a module
> param for read only apic id, will work for me.

Sadly, I don't think a module param would actually help.  I was thinking it would
avoid breakage by allowing for graceful fallback on migration failure, but that
was wishful thinking.  An inhibit seems like the least awful idea if we don't end
up making it unconditionally readonly.

> All I wanted to do is to make KVM better by simplifying it - KVM is already
> as complex as it can get, anything to make it simpler is welcome IMHO.

I agree that simplifying KVM is a goal, and that we need to decide when enough is
enough.  But we also can't break userspace or existing deployments, that's a very
clearly drawn line in Linux.

My biggest worry is that, unlike the KVM_SET_CPUID2 breakage, which was obvious
and came relatively quick, this could cause breakage at the worst possible time
(migration) months or years down the road.

Since the goal is to simplify KVM, can we try the inhibit route and see what the
code looks like before making a decision?  I think it might actually yield a less
awful KVM than the readonly approach, especially if the inhibit is "sticky", i.e.
we don't try to remove the inhibit on subsequent changes.

Killing the VM, as proposed, is very user unfriendly as the user will have no idea
why the VM was killed.  WARN is out of the question because this is user triggerable.
Returning an emulation error would be ideal, but getting that result up through
apic_mmio_write() could be annoying and end up being more complex.

The touchpoints will all be the same, unless I'm missing something the difference
should only be a call to set an inhibit instead killing the VM.
