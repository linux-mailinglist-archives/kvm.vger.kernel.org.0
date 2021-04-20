Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE220365F20
	for <lists+kvm@lfdr.de>; Tue, 20 Apr 2021 20:21:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233245AbhDTSWW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Apr 2021 14:22:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232879AbhDTSWT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Apr 2021 14:22:19 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6F9CC06174A
        for <kvm@vger.kernel.org>; Tue, 20 Apr 2021 11:21:47 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id o16so6521530plg.5
        for <kvm@vger.kernel.org>; Tue, 20 Apr 2021 11:21:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=vrF8syNtvi8MTUMiAAXA/Clz1Cv2NTynYHq8T0jl3hc=;
        b=UT1TVF9HvxVD6sWsgYP/1DEbZNOAb0TEnyKd/Bd5nbiuHAaTlFDCbb5skiZtsrl8MN
         wXlYPCdppgSfZhf5sueiX4xUe5c9WTupRCI1sauFHBxBKFiNx/wywnuPHpYXa18whuAU
         BDCW6VjizWmVuUUZi1kMK6rQhOmpcdmdIBSDY85iePFpOblVOC4T12Dk3scpslYWpb7e
         1NZIHDi3TMWNSCMg6EOUZjavB1JPSt8dnjjMSCR6QFxaoq7Y+RqoKpXFfPwzS1TVXVVG
         UsCXKGcYUUFLUJyIoREc4TDAacxmrZWyJpAm2XcWiC0WlNPeBnX1sVdA9HYldw7aqZmo
         gk0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=vrF8syNtvi8MTUMiAAXA/Clz1Cv2NTynYHq8T0jl3hc=;
        b=iDfBUI4v+bhI9wsI6n3Hh0r0oP89yDiB41Z7AeiitmGR0bqTMoICPtEfFs25wF5K4w
         ueOcngjU0WjnntfhZflBN+0T5IXzQ5nJPOvPEfRTBaEvGmbIWrCp8S/y4vkqc1SPMfBp
         niKlbUlNTQRBV0gd3PE4pcY5NVif/1aFzqWbZqnMJzGtf94EwHEqOoh7kWWYqhz8WCK/
         S99yV4gggyXDg/wLnqeJq5WNyq4T8sG52jvQyzA951575ogw6W0dNYO53buKc+/c7fOD
         w6xHJODnKAjyc4M+hAWgWRNFh1/pdSoZqzsaJAqJjDIrcC4pj6hpl02vLltpM7mKfnl/
         Q/Rw==
X-Gm-Message-State: AOAM530UuuydjmLlqiIKVJMMCtAKZC90n0kiAhfO5ESgHzB0GOPtj/RA
        Ihf6SSHTd5k5tJCPx3W9RNgBsw==
X-Google-Smtp-Source: ABdhPJzHelQ69nDT+yfI/8ngPfXICJYB0pz+bCtV3K3qRKiBXhMk49PydGHMGv1m22zRRFMOZTDmbQ==
X-Received: by 2002:a17:902:20e:b029:ec:a39a:4194 with SMTP id 14-20020a170902020eb02900eca39a4194mr12566484plc.31.1618942906998;
        Tue, 20 Apr 2021 11:21:46 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id t10sm3102532pjy.16.2021.04.20.11.21.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Apr 2021 11:21:46 -0700 (PDT)
Date:   Tue, 20 Apr 2021 18:21:42 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     David Edmondson <dme@dme.org>
Cc:     Aaron Lewis <aaronlewis@google.com>,
        Jim Mattson <jmattson@google.com>,
        kvm list <kvm@vger.kernel.org>
Subject: Re: [PATCH 1/2] kvm: x86: Allow userspace to handle emulation errors
Message-ID: <YH8btp+ilY93fKN0@google.com>
References: <20210416131820.2566571-1-aaronlewis@google.com>
 <cunblaaqwe0.fsf@dme.org>
 <CAAAPnDEEwLRMLZffJSN5W93d5s6EQJuAP58vAVJCo+RZD6ahsA@mail.gmail.com>
 <cunzgxtctgj.fsf@dme.org>
 <CAAAPnDGnY76C-=FppsiL=OFY-ei8kHeJhfK_tNV8of3JHBZ0FA@mail.gmail.com>
 <cunbla8c2y3.fsf@dme.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cunbla8c2y3.fsf@dme.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 20, 2021, David Edmondson wrote:
> On Tuesday, 2021-04-20 at 07:57:27 -07, Aaron Lewis wrote:
> 
> >> >> Why not add a new exit reason, particularly given that the caller has to
> >> >> enable the capability to get the relevant data? (It would also remove
> >> >> the need for the flag field and any mechanism for packing multiple bits
> >> >> of detail into the structure.)
> >> >
> >> > I considered that, but I opted for the extensibility of the exiting
> >> > KVM_EXIT_INTERNAL_ERROR instead.  To me it was six of one or half a
> >> > dozen of the other.  With either strategy I still wanted to provide
> >> > for future extensibility, and had a flags field in place.  That way we
> >> > can add to this in the future if we find something that is missing
> >> > (ie: potentially wanting a way to mark dirty pages, possibly passing a
> >> > fault address, etc...)
> >>
> >> How many of the flag based optional fields do you anticipate needing for
> >> any one particular exit scenario?
> >>
> >> If it's one, then using the flags to disambiguate the emulation failure
> >> cases after choosing to stuff all of the cases into
> >> KVM_EXIT_INTERNAL_ERROR / KVM_INTERNAL_ERROR_EMULATION would be odd.
> >>
> >> (I'm presuming that it's not one, but don't understand the use case.)
> >
> > The motivation was to allow for maximum flexibility in the future, and
> > not be tied down to something we potentially missed now.  I agree the
> > flags aren't needed if we are only adding to what's currently there,
> > but they are needed if we want to remove something or pack something
> > differently.  I didn't see how I could achieve that without adding a
> > flags field.  Seemed like low overhead to be more future proof.
> 
> With what you have now, the ndata field seems unnecessary - I should be
> able to determine the contents of the rest of the structure based on the
> flags.

Keeping ndata is necessary if we piggyback KVM_INTERNAL_ERROR_EMULATION,
otherwise we'll break for VMMs that are not aware of the new format.  E.g. if
ndata gets stuffed with a large number, KVM could cause a buffer overrun in an
old VMM.

> That also suggests to me that using something other than
> KVM_INTERNAL_ERROR_EMULATION would make sense.

Like Aaron, I'm on the fence as to whether or not a new exit reason is in order.
On one hand, it would be slightly cleaner.  On the other hand, the existing
"KVM_INTERNAL_ERROR_EMULATION" really is the best name.  It implies nothing
about the userspace VMM, only that KVM attempted to emulate an instruction and
failed.

The other motivation is that KVM can opportunistically start dumping extra info
for old VMMs, though this patch does not do that; feedback imminent. :-)

> This comment:
> 
> >> >> > + * When using the suberror KVM_INTERNAL_ERROR_EMULATION, these flags are used
> >> >> > + * to describe what is contained in the exit struct.  The flags are used to
> >> >> > + * describe it's contents, and the contents should be in ascending numerical
> >> >> > + * order of the flag values.  For example, if the flag
> >> >> > + * KVM_INTERNAL_ERROR_EMULATION_FLAG_INSTRUCTION_BYTES is set, the instruction
> >> >> > + * length and instruction bytes would be expected to show up first because this
> >> >> > + * flag has the lowest numerical value (1) of all the other flags.
> 
> originally made me think that the flag-indicated elements were going to
> be packed into the remaining space of the structure at a position
> depending on which flags are set.
> 
> For example, if I add a new flag
> KVM_INTERNAL_ERROR_EMULATION_FLAG_EXIT_CODE, value 2, and then want to
> pass back an exit code but *not* instruction bytes, the comment appears
> to suggest that the exit code will appear immediately after the flags.
> 
> This is contradicted by your other reply:
> 
> >> > Just add the fields you need to
> >> > the end of emulation_failure struct, increase 'ndata' to the new
> >> > count, add a new flag to 'flags' so we know its contents.
> 
> Given this, the ordering of flag values does not seem significant - the
> structure elements corresponding to a flag value will always be present,
> just not filled with relevant data.

I think what Aaron is trying to say is that the order in the aliased data[] is
associated with the lowest _defined_ flag value, not the lowest _set_ flag.

That said, I would just omit the "ascending numerical" stuff entirely, e.g. I
think for the #defines, this will suffice:

/* Flags that describe what fields in emulation_failure hold valid data  */


As for not breaking userspace if/when additional fields are added, we can instead
document the new struct (and drop my snarky comment :-D), e.g.:

		/*
		 * KVM_INTERNAL_ERROR_EMULATION
		 *
		 * "struct emulation_failure" is an overlay of "struct internal"
		 * that is used for the KVM_INTERNAL_ERROR_EMULATION sub-type of
		 * KVM_EXIT_INTERNAL_ERROR.  Note, unlike other internal error
		 * sub-types, this struct is ABI!  It also needs to be backwards
		 * compabile with "struct internal".  Take special care that
		 * "ndata" is correct, that new fields are enumerated in "flags",
		 * and that each flag enumerates fields that are 64-bit aligned
		 * and sized (so that ndata+internal.data[] is valid/accurate).
		 */
		struct {
			__u32 suberror;
			__u32 ndata;
			__u64 flags;
			__u8  insn_size;
			__u8  insn_bytes[15];
		} emulation_failure;


