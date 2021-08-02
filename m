Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C6113DDE24
	for <lists+kvm@lfdr.de>; Mon,  2 Aug 2021 18:58:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232190AbhHBQ6T (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Aug 2021 12:58:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229797AbhHBQ6S (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Aug 2021 12:58:18 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07AF1C0613D5
        for <kvm@vger.kernel.org>; Mon,  2 Aug 2021 09:58:08 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id c16so20331595plh.7
        for <kvm@vger.kernel.org>; Mon, 02 Aug 2021 09:58:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=67UCcXw6Bwoz9yHjZZDcAJ+wIZA32YKluf+gMvwDLEg=;
        b=AYyNS5HBgapBPr9RswDyouJAQcviXGYaBRing3fUZOGZ/CaN+DEPCDiRLPDi1oGf3g
         AH0o3pLecIc8tzPHY/9A256deoWzNr+LNKvRr6DdM3fIDisWniBMC/CLUUf8Ntcf1pT5
         Zd6U0zQ/DupQV8dYaahn6Nbj1zQWOWxLsXzE8Poz4x6gf+361OXm+2B5td35xkbHJV73
         7jMDKuLSQK45yC+nug7PEC4bhebnRmh7Dy1jt1/BNYpwOAEALOsj3kCWlz4hfTTfBFe/
         Y/bbQnOmjHAUgevRxnY9LbWH295Opk9Rq4DTHqA97KnMCdZRdxJXZywSyawku2LVSSiY
         XD0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=67UCcXw6Bwoz9yHjZZDcAJ+wIZA32YKluf+gMvwDLEg=;
        b=nU00bOxwsY4D0VR/aBphdzFTPh89PwROJ9jmKlLJ2IaDc4v6E78wY2zBOwsMhEqigQ
         gD/6Q9c3iIhyW92nEPhXDV/eQEi1a15mbLBL9MyIEYSqnyhfQxMH/vFr7mhw9ytyptbw
         4BfR2xikOdijBHJwtgskpzHBE3WKvZz3GVMR/vjKqeUaPoB0B2GkHmGOv4uIcFQOVoKG
         FbFienUhiQhaHa8+4cqyp+1tlg1/mXW4NOkQJYWgz4eKM0Qhp4r66+rZnUgjuMXDq0+N
         xsrhk01MNT5mytEYpNgt/ukYGSe/xy14sT1gioH+MlMFGecicNJfz1doJaluMMJGzKLs
         4NeA==
X-Gm-Message-State: AOAM531wDsZsI49eSyryIC4dMTkc3pOXs2Lmu8NgGcOWK5m9Pcrf8Hdc
        BKRssQCaQoHrsb4DyJPFwGmBCg==
X-Google-Smtp-Source: ABdhPJzd04ClYJnQ645mP57EXMTmUJraBrjjimwiy45nqkuGWAfqZEHd+NGWKFwE19xucv5mGbSWbg==
X-Received: by 2002:a05:6a00:1951:b029:333:64d3:e1f1 with SMTP id s17-20020a056a001951b029033364d3e1f1mr17948484pfk.43.1627923487274;
        Mon, 02 Aug 2021 09:58:07 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id o9sm13248081pfh.217.2021.08.02.09.58.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Aug 2021 09:58:06 -0700 (PDT)
Date:   Mon, 2 Aug 2021 16:58:03 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     David Edmondson <david.edmondson@oracle.com>
Cc:     linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Joerg Roedel <joro@8bytes.org>, Ingo Molnar <mingo@redhat.com>,
        Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org,
        Borislav Petkov <bp@alien8.de>,
        David Matlack <dmatlack@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joao Martins <joao.m.martins@oracle.com>
Subject: Re: [PATCH v3 2/3] KVM: x86: On emulation failure, convey the exit
 reason, etc. to userspace
Message-ID: <YQgkGwGkrleO7I2A@google.com>
References: <20210729133931.1129696-1-david.edmondson@oracle.com>
 <20210729133931.1129696-3-david.edmondson@oracle.com>
 <YQR52JRv8jgj+Dv8@google.com>
 <cunk0l4mhjc.fsf@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cunk0l4mhjc.fsf@oracle.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Aug 02, 2021, David Edmondson wrote:
> On Friday, 2021-07-30 at 22:14:48 GMT, Sean Christopherson wrote:
> 
> > On Thu, Jul 29, 2021, David Edmondson wrote:
> >> +		__u64 exit_info1;
> >> +		__u64 exit_info2;
> >> +		__u32 intr_info;
> >> +		__u32 error_code;
> >> +	} exit_reason;
> >
> > Oooh, you're dumping all the fields in kvm_run.  That took me forever to realize
> > because the struct is named "exit_reason".  Unless there's a naming conflict,
> > 'data' would be the simplest, and if that's already taken, maybe 'info'?
> >
> > I'm also not sure an anonymous struct is going to be the easiest to maintain.
> > I do like that the fields all have names, but on the other hand the data should
> > be padded so that each field is in its own data[] entry when dumped to userspace.
> > IMO, the padding complexity isn't worth the naming niceness since this code
> > doesn't actually care about what each field contains.
> 
> Given that this is avowedly not an ABI and that we are expecting any
> (human) consumer to be intimate with the implementation to make sense of
> it, is there really any requirement or need for padding?

My thought with the padding was to force each field into its own data[] entry.
E.g. if userspace does something like

	for (i = 0; i < ndata; i++)
		printf("\tdata[%d] = 0x%llx\n", i, data[i]);

then padding will yield

	data[0] = flags
	data[1] = exit_reason
	data[2] = exit_info1
	data[3] = exit_info2
	data[4] = intr_info
	data[5] = error_code

versus

	data[0] = <flags>
	data[1] = (exit_info1 << 32) | exit_reason
	data[2] = (exit_info2 << 32) | (exit_info1 >> 32)
	data[3] = (intr_info << 32) | (exit_info2 >> 32)
	data[4] = error_code

Changing exit_reason to a u64 would clean up the worst of the mangling, but until
there's actually a 64-bit exit reason to dump, that's just a more subtle way to
pad the data.

> In your example below (most of which I'm fine with), the padding has the
> effect of wasting space that could be used for another u64 of debug
> data.

Yes, but because it's not ABI, we can change it in the future if we get to the
point where we want to dump more info and don't have space.  Until that time, I
think it makes sense to prioritize readability with an ignorant (of the format)
userspace over memory footprint.

> > 	/*
> > 	 * There's currently space for 13 entries, but 5 are used for the exit
> > 	 * reason and info.  Restrict to 4 to reduce the maintenance burden
> > 	 * when expanding kvm_run.emulation_failure in the future.
> > 	 */
> > 	if (WARN_ON_ONCE(ndata > 4))
> > 		ndata = 4;
> >
> > 	if (insn_size) {
> > 		ndata_start = 3;
> > 		run->emulation_failure.flags =
> > 			KVM_INTERNAL_ERROR_EMULATION_FLAG_INSTRUCTION_BYTES;
> > 		run->emulation_failure.insn_size = insn_size;
> > 		memset(run->emulation_failure.insn_bytes, 0x90,
> > 		       sizeof(run->emulation_failure.insn_bytes));
> > 		memcpy(run->emulation_failure.insn_bytes, insn_bytes, insn_size);
> > 	} else {
> > 		/* Always include the flags as a 'data' entry. */
> > 		ndata_start = 1;
> > 		run->emulation_failure.flags = 0;
> > 	}
> 
> When we add another flag (presuming that we do, because if not there was
> not much point in the flags) this will have to be restructured again. Is
> there an objection to the original style? (prime ndata=1, flags=0, OR in
> flags and adjust ndata as we go.)

No objection, though if you OR in flags then you should truly _adjust_ ndata, not
set it, e.g.

        /* Always include the flags as a 'data' entry. */
        ndata_start = 1;
        run->emulation_failure.flags = 0;

        if (insn_size) {
                ndata_start += 2;  <----------------------- Adjust, not override
                run->emulation_failure.flags |=
                        KVM_INTERNAL_ERROR_EMULATION_FLAG_INSTRUCTION_BYTES;
                run->emulation_failure.insn_size = insn_size;
                memset(run->emulation_failure.insn_bytes, 0x90,
                       sizeof(run->emulation_failure.insn_bytes));
                memcpy(run->emulation_failure.insn_bytes, insn_bytes, insn_size);
        }

> > 	memcpy(&run->internal.data[ndata_start], info, ARRAY_SIZE(info));
> > 	memcpy(&run->internal.data[ndata_start + ARRAY_SIZE(info)], data, ndata);
> > }
