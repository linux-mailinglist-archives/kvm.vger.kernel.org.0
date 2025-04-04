Return-Path: <kvm+bounces-42618-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 3D05DA7B5EA
	for <lists+kvm@lfdr.de>; Fri,  4 Apr 2025 04:39:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 911BC18900ED
	for <lists+kvm@lfdr.de>; Fri,  4 Apr 2025 02:39:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EB801482EB;
	Fri,  4 Apr 2025 02:39:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=citrix.com header.i=@citrix.com header.b="PDGGr5Ao"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 994944A32
	for <kvm@vger.kernel.org>; Fri,  4 Apr 2025 02:39:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743734379; cv=none; b=aZCRoON5Vfa0uFWBo5xV4MeaHHwVtazMnauN8Vap8mjTy3nFvrpl8zni0zQ3zdd6r5l9nCRwSwLJZbiWuGitpxGdvXUd6YabNqBb87GSAAr0WktnXM4Z9zy0BYlcPeoKrQWoUZESgdmS+4t9N4DEWmtZpCHtVkS/rHcnq/qO68E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743734379; c=relaxed/simple;
	bh=0G6rqP5mSwe8XwGq32ciWsfmoN1SBfyghJ10tXmCyac=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UjeHGuX22d+fBGGl/0GRYC+j+HASj+rpSna2jjUa9oRI8qWNYID61D60XyYN5jM43OITIEnYq+Hnndl2QBfcEkAugA2lPo/RLw3zMZEg/l76gK0iuwW+/kKCnyj+Dxt+Uzj2PiAWSBwRwV+r+7gSBTb4rcZ5a+0YRKt5y1INef0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=citrix.com; spf=pass smtp.mailfrom=cloud.com; dkim=pass (1024-bit key) header.d=citrix.com header.i=@citrix.com header.b=PDGGr5Ao; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=citrix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cloud.com
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-4394a823036so14407165e9.0
        for <kvm@vger.kernel.org>; Thu, 03 Apr 2025 19:39:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=citrix.com; s=google; t=1743734375; x=1744339175; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=lFaUqdZI1ex+oj33UsFQHXEBb21N+ETuCDGOxwRj0Xc=;
        b=PDGGr5AoCBLgjeSRu+qcdkC7zqjgYha3z3/Ns4r+/FD83oHNBXUkIpT3vXQg2Klu5Y
         1GVVT72DMAtKvyLqK19yj2TP3w6wIi59rIEA8xC7wLWw1KNtWAG9Twv+11/eOcq7Fvlm
         uempgmC3rWRIiyh0eBEisJUvFS4GTf8nnLL1g=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743734375; x=1744339175;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lFaUqdZI1ex+oj33UsFQHXEBb21N+ETuCDGOxwRj0Xc=;
        b=QtS5BCIt+16zda3arN3cXZT+3hfQTXo/UgTC6/PhisiOMCVF13b2Cd/etEM+lHCX6q
         Vz2OA5nGhD2S0hrHCaJc9XzKn0SPRJCVt+I1RIC4+UT1B9eu2GABI7MLGY3x/du4C/fa
         /NlcYK1s1WNqI3nksFPl40fsB7FcmEVvFSaqiiXVonSRaT2rHiKa1jpEv5pNEXcdU/MO
         ECvRjTeMcPl4j0pYDp4JVJ0FrfskKGDnAuwOGLJrzYhSIBxXknEnVlwk++ARr8mA36Xv
         QB3mqq+GrnLOxYABJhlcOw3n/9L/fkHw32WZbrJvWds9wKCHQdZrrTbYAog15/PPKBxN
         M1/A==
X-Forwarded-Encrypted: i=1; AJvYcCXr9aZR3EUfTIAPHzvGl0EdyW58FvgQExzZ4ERNYqZcK3LAn+68GbaYtxQPtnXUccLgXhg=@vger.kernel.org
X-Gm-Message-State: AOJu0YxnkPB5ISUvQP8vSCkdohGYwGXLkjjFhE9EKiMfnaBuP26HH4Pv
	wtFjR/GwuD9lxoBPOOnPEdTQVPl0GMW832i3ig3ZucdWGdsSui+G2xLTBUvAaoo=
X-Gm-Gg: ASbGnctBKnVAp5sG2GLb5Jh2PASpH+N13X13a7gUk/FivnxyHGUsDumY8NPb12VYX7m
	QBQNC2C0Ieuh7qgyDKkbA83EjMoGiizSB5EEGlsAUK9xzo1uy7tiEUauTD4puBijyGrfghfgjhe
	ahzgNbiHBoREa7GFjMlpBqKqzPJ4RJyGgR0SPmSzH05WlfLEySJH3iAKZ/LJGEnJ6ciO6Hq7pHh
	znJ8XsnuWtH/HgAKKehrwLAYGQuRC/3Cd0godw1zN9LpTwVWFFSbeh6cWxSvvc6SE4LPhO7UbcO
	dBu/M51AdG+9zLqjU8qW66aIz0372MTw44wPctln2YesumjkIp/2s/oLofHqkmA9O+VYNp/z6oP
	/GXWqO+6W2w==
X-Google-Smtp-Source: AGHT+IGVswomjphYIoMeIWyYWiahO403HK25HEqheOKFFyEAFDKE5K2JSDbvnOI185exqTxnK+uESA==
X-Received: by 2002:a05:600c:4594:b0:43c:ec28:d310 with SMTP id 5b1f17b1804b1-43ecf8837d8mr11835415e9.10.1743734374727;
        Thu, 03 Apr 2025 19:39:34 -0700 (PDT)
Received: from [192.168.1.183] (host-92-26-98-202.as13285.net. [92.26.98.202])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-39c301a9bcfsm3252492f8f.33.2025.04.03.19.39.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Apr 2025 19:39:34 -0700 (PDT)
Message-ID: <2b32a422-575a-403c-b373-1c6beac47c83@citrix.com>
Date: Fri, 4 Apr 2025 03:39:32 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 6/6] x86/bugs: Add RSB mitigation document
To: Josh Poimboeuf <jpoimboe@kernel.org>, x86@kernel.org
Cc: linux-kernel@vger.kernel.org, amit@kernel.org, kvm@vger.kernel.org,
 amit.shah@amd.com, thomas.lendacky@amd.com, bp@alien8.de,
 tglx@linutronix.de, peterz@infradead.org, pawan.kumar.gupta@linux.intel.com,
 corbet@lwn.net, mingo@redhat.com, dave.hansen@linux.intel.com,
 hpa@zytor.com, seanjc@google.com, pbonzini@redhat.com,
 daniel.sneddon@linux.intel.com, kai.huang@intel.com, sandipan.das@amd.com,
 boris.ostrovsky@oracle.com, Babu.Moger@amd.com, david.kaplan@amd.com,
 dwmw@amazon.co.uk
References: <cover.1743617897.git.jpoimboe@kernel.org>
 <d6c07c8ae337525cbb5d926d692e8969c2cf698d.1743617897.git.jpoimboe@kernel.org>
Content-Language: en-GB
From: Andrew Cooper <andrew.cooper3@citrix.com>
Autocrypt: addr=andrew.cooper3@citrix.com; keydata=
 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
 6+ahAA==
In-Reply-To: <d6c07c8ae337525cbb5d926d692e8969c2cf698d.1743617897.git.jpoimboe@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 02/04/2025 7:19 pm, Josh Poimboeuf wrote:
> Create a document to summarize hard-earned knowledge about RSB-related
> mitigations, with references, and replace the overly verbose yet
> incomplete comments with a reference to the document.
>
> Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>

Excellent.  I've been trying to do something like this for a while, and
not managing to get this far.

> diff --git a/Documentation/admin-guide/hw-vuln/rsb.rst b/Documentation/admin-guide/hw-vuln/rsb.rst
> new file mode 100644
> index 000000000000..97bf75993d5d
> --- /dev/null
> +++ b/Documentation/admin-guide/hw-vuln/rsb.rst
> @@ -0,0 +1,241 @@
> +.. SPDX-License-Identifier: GPL-2.0
> +
> +=======================
> +RSB-related mitigations
> +=======================
> +
> +.. warning::
> +   Please keep this document up-to-date, otherwise you will be
> +   volunteered to update it and convert it to a very long comment in
> +   bugs.c!
> +
> +Since 2018 there have been many Spectre CVEs related to the Return Stack
> +Buffer (RSB).

2017.  I, and many others, spent the whole second half of 2017 tied up
in all of this.

I'd drop the Spectre, or swap it for Speculation-related.  Simply
"Spectre" CVEs tend to focus on the conditional and indirect predictors.

>   Information about these CVEs and how to mitigate them is
> +scattered amongst a myriad of microarchitecture-specific documents.

You should note that the AMD terms RAS and RAP are the same thing,
considering that you link to the documents.

> +
> +This document attempts to consolidate all the relevant information in
> +once place and clarify the reasoning behind the current RSB-related
> +mitigations.
> +
> +At a high level, there are two classes of RSB attacks: RSB poisoning
> +(Intel and AMD) and RSB underflow (Intel only).  They must each be
> +considered individually for each attack vector (and microarchitecture
> +where applicable).
> +

One question before getting further.  This seems to be focused on
(mis)prediction of RETs ?

That's fine, but it wants spelling out, because it is distinct from the
other class of issues when RET instructions execute in bad ways.

When lecturing, my go-to example is Spectre-v1.1 / BCBS (store which
clobbers or aliases the return address), because an astounding number of
things can go wrong in different ways from there.


Next, before diving into the specifics, it's incredibly relevant to have
a section briefly describing how the RSB typically works.  It's key to
understanding the rest of the documents, and there will definitely be
people reading the document who don't know it.

The salient points are (on CPUs since ~Nehalem era.  Confirm with Intel
and AMD.  You can spot it in the optimisation guides, because it's where
the phrase such as "only taken branches consume prediction resource"
began appearing):

* Branch prediction is **prior** to instruction decode, and guesses at
the location, type, and target of all near branches.
* The RSB is a prediction structure used by branches predicted as CALLs
or RETs.
* When a CALL is predicted, the predicted return-address is pushed on
the RSB
* When a RET is predicted, the RSB is popped
* Later, decode will cross-check the prediction with the instruction
stream.  It can issue corrections to the predictor state, and restart
prediction/fetch from the point that things appeared to go wrong.  This
can include editing transient state in the RSB.

For the observant reader, yes, the RSB is filled using predicted
targets.  This is why the SRSO vuln is so evil.

So, with the behaviour summarised, next some properties (disclaimer:
varies by vendor)
* It is logically a stack, but has finite capacity.  Executing more RET
instructions than CALLs will underflow it.
** AMD reuses the -1'th entry and doesn't move the pointer
** Intel may fall back to a prediction from a different predictor
* It is a structure shared across all security domains in Core/Thread. 
Guest & Host is most relevant to the doc, but SMM/ACM/SEAM/XuCode are
all included.
** Some AMD CPUs dynamically re-partition the RSB(RAS) when a sibling
thread goes idle
** Some Intel CPUs only have a 32-bit wide RSB, and reuse the upper bits
of the location for the predicted target
** Some Intel CPUs hardwire bit 47(?) which causes the kernel to follow
userspace predictions.

> +----
> +
> +RSB poisoning (Intel and AMD)
> +=============================
> +
> +SpectreRSB
> +~~~~~~~~~~
> +
> +RSB poisoning is a technique used by Spectre-RSB [#spectre-rsb]_ where
> +an attacker poisons an RSB entry to cause a victim's return instruction
> +to speculate to an attacker-controlled address.  This can happen when
> +there are unbalanced CALLs/RETs after a context switch or VMEXIT.
> +
> +* All attack vectors can potentially be mitigated by flushing out any
> +  poisoned RSB entries using an RSB filling sequence
> +  [#intel-rsb-filling]_ [#amd-rsb-filling]_ when transitioning between
> +  untrusted and trusted domains.  But this has a performance impact and
> +  should be avoided whenever possible.

More importantly, 32-entry RSB stuffing loops are only applicable to
pre-eIBRS and pre-ERAPS hardware.

They are known unsafe to use on newer microarchitectures, inc Gracemont
(128 entries) and Zen5 (64 entries).

> +
> +* On context switch, the user->user mitigation requires ensuring the
> +  RSB gets filled or cleared whenever IBPB gets written [#cond-ibpb]_
> +  during a context switch:
> +
> +  * AMD:
> +	IBPB (or SBPB [#amd-sbpb]_ if used) automatically clears the RSB
> +	if IBPB_RET is set in CPUID [#amd-ibpb-rsb]_.  Otherwise the RSB
> +	filling sequence [#amd-rsb-filling]_ must be always be done in
> +	addition to IBPB.

Honestly, I dislike this way of characterising it.   IBPB was very
clearly spec'd to flush all indirect prediction structures, and some AMD
CPUs have an errata where this isn't true and has to be filled in by the OS.

> +
> +  * Intel:
> +	IBPB automatically clears the RSB:
> +
> +	"Software that executed before the IBPB command cannot control
> +	the predicted targets of indirect branches executed after the
> +	command on the same logical processor. The term indirect branch
> +	in this context includes near return instructions, so these
> +	predicted targets may come from the RSB." [#intel-ibpb-rsb]_
> +
> +* On context switch, user->kernel attacks are mitigated by SMEP, as user
> +  space can only insert its own return addresses into the RSB:

It's more subtle than this (see the 32-bit wide prediction).

A user/supervisor split address space limits the ranges of addresses
that userspace can insert into the predictor.

There is a corner case at the canonical boundary.  Userspace can insert
the first non-canonincal address, and on some CPUs, this is interpreted
as the first high canonical address.  Guard pages on both sides of the
canonical boundary mitigate this.

In the unbalanced case for user->kernel, a bad prediction really is made
(coming out of the RSB), and it's only the SMEP #PF at instruction fetch
which prevents you speculatively executing in userspace.

In the 32-bit width case, the kernel predicts to {high_kern:low_user}
target.


> +
> +  * AMD:
> +	"Finally, branches that are predicted as 'ret' instructions get
> +	their predicted targets from the Return Address Predictor (RAP).
> +	AMD recommends software use a RAP stuffing sequence (mitigation
> +	V2-3 in [2]) and/or Supervisor Mode Execution Protection (SMEP)
> +	to ensure that the addresses in the RAP are safe for
> +	speculation. Collectively, we refer to these mitigations as "RAP
> +	Protection"." [#amd-smep-rsb]_
> +
> +  * Intel:
> +	"On processors with enhanced IBRS, an RSB overwrite sequence may
> +	not suffice to prevent the predicted target of a near return
> +	from using an RSB entry created in a less privileged predictor
> +	mode.  Software can prevent this by enabling SMEP (for
> +	transitions from user mode to supervisor mode) and by having
> +	IA32_SPEC_CTRL.IBRS set during VM exits." [#intel-smep-rsb]_
> +
> +* On VMEXIT, guest->host attacks are mitigated by eIBRS (and PBRSB
> +  mitigation if needed):
> +
> +  * AMD:
> +	"When Automatic IBRS is enabled, the internal return address
> +	stack used for return address predictions is cleared on VMEXIT."
> +	[#amd-eibrs-vmexit]_
> +
> +  * Intel:
> +	"On processors with enhanced IBRS, an RSB overwrite sequence may
> +	not suffice to prevent the predicted target of a near return
> +	from using an RSB entry created in a less privileged predictor
> +	mode.  Software can prevent this by enabling SMEP (for
> +	transitions from user mode to supervisor mode) and by having
> +	IA32_SPEC_CTRL.IBRS set during VM exits. Processors with
> +	enhanced IBRS still support the usage model where IBRS is set
> +	only in the OS/VMM for OSes that enable SMEP. To do this, such
> +	processors will ensure that guest behavior cannot control the
> +	RSB after a VM exit once IBRS is set, even if IBRS was not set
> +	at the time of the VM exit." [#intel-eibrs-vmexit]_
> +
> +    Note that some Intel CPUs are susceptible to Post-barrier Return
> +    Stack Buffer Predictions (PBRSB)[#intel-pbrsb]_, where the last CALL
> +    from the guest can be used to predict the first unbalanced RET.  In
> +    this case the PBRSB mitigation is needed in addition to eIBRS.
> +
> +AMD Retbleed / SRSO / Branch Type Confusion
> +~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> +
> +On AMD, poisoned RSB entries can also be created by the AMD Retbleed
> +variant [#retbleed-paper]_ and/or Speculative Return Stack Overflow
> +[#amd-srso]_ (Inception [#inception-paper]_).  These attacks are made
> +possible by Branch Type Confusion [#amd-btc]_.  The kernel protects
> +itself by replacing every RET in the kernel with a branch to a single
> +safe RET.

BTC and SRSO are unrelated things.

"predicted branch types" is an inherent property of the predictor.  BTC
is specifically the case where decode doesn't halt, and still issues the
wrong uops into the pipeline to execute.

SRSO goes entirely wrong at the BP/IF stages (BP racing ahead while IF
is stalled unable to fetch anything), so the damage is done by the time
Decode sees the instruction stream.


You also need to cover the AMD going-idle issue where the other thread's
RSB entries magically appear in my RSB, and my head/tail pointer is
reset to a random position.

> +
> +----
> +
> +RSB underflow (Intel only)
> +==========================

Well, not really.  AMD can underflow too.  It just picks a fixed entry
and keeps on reusing that.  (Great for the alarming number of
programming languages which consider recursion a virtue.)

> +
> +Intel Retbleed
> +~~~~~~~~~~~~~~
> +
> +Some Intel Skylake-generation CPUs are susceptible to the Intel variant
> +of Retbleed [#retbleed-paper]_ (Return Stack Buffer Underflow
> +[#intel-rsbu]_).  If a RET is executed when the RSB buffer is empty due
> +to mismatched CALLs/RETs or returning from a deep call stack, the branch
> +predictor can fall back to using the Branch Target Buffer (BTB).  If a
> +user forces a BTB collision then the RET can speculatively branch to a
> +user-controlled address.
> +
> +* Note that RSB filling doesn't fully mitigate this issue.  If there
> +  are enough unbalanced RETs, the RSB may still underflow and fall back
> +  to using a poisoned BTB entry.
> +
> +* On context switch, user->user underflow attacks are mitigated by the
> +  conditional IBPB [#cond-ibpb]_ on context switch which clears the BTB:
> +
> +  * "The indirect branch predictor barrier (IBPB) is an indirect branch
> +    control mechanism that establishes a barrier, preventing software
> +    that executed before the barrier from controlling the predicted
> +    targets of indirect branches executed after the barrier on the same
> +    logical processor." [#intel-ibpb-btb]_
> +
> +    .. note::
> +       I wasn't able to find any offical documentation from Intel
> +       explicitly stating that IBPB clears the BTB.  However, it's
> +       broadly known to be true and relied upon in several mitigations.

Part of this is because when the vendors say the BTB, they're
translating their internal names into what academia calls them.

"Flush the BTB" isn't a helpful statement anyway.  See AMD's IBPB vs
SBPB which controls whether the branch types predictions remain intact.

Given how many rounds of Intel microcode there have been making IBPB
scrub more, it clearly wasn't scrubbing everything in the first place.

> +
> +* On context switch and VMEXIT, user->kernel and guest->host underflows
> +  are mitigated by IBRS or eIBRS:
> +
> +  * "Enabling IBRS (including enhanced IBRS) will mitigate the "RSBU"
> +    attack demonstrated by the researchers.

Yeah, except it doesn't.  Intra-mode BTI is a thing, and that will leak
your secrets too.

>  As previously documented,
> +    Intel recommends the use of enhanced IBRS, where supported. This
> +    includes any processor that enumerates RRSBA but not RRSBA_DIS_S."
> +    [#intel-rsbu]_
> +
> +  As an alternative to classic IBRS, call depth tracking can be used to

legacy IBRS.  Please don't invent yet another term for it :), and
"classic" further implies there might be a time when anyone looks back
fondly on it.

> +  track kernel returns and fill the RSB when it gets close to being
> +  empty.
> +
> +Restricted RSB Alternate (RRSBA)
> +~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

This needs to discuss RSBA and RRSBA.  They're distinct.  To a first
approximation, RRSBA == RSBA + eIBRS.  The "restricted" nature is
"mode-tagged predictions".

Except there's a narrow range of CPUs around Icelake which have eIBRS
and do not suffer (R)RSBA.

> +
> +Some newer Intel CPUs have Restricted RSB Alternate (RRSBA) behavior,
> +which, similar to the Intel variant of Retbleed described above, also
> +falls back to using the BTB on RSB underflow.  The only difference is
> +that the predicted targets are restricted to the current domain.
> +
> +* "Restricted RSB Alternate (RRSBA) behavior allows alternate branch
> +  predictors to be used by near RET instructions when the RSB is
> +  empty.  When eIBRS is enabled, the predicted targets of these
> +  alternate predictors are restricted to those belonging to the
> +  indirect branch predictor entries of the current prediction domain.
> +  [#intel-eibrs-rrsba]_
> +
> +When a CPU with RRSBA is vulnerable to Branch History Injection
> +[#bhi-paper]_ [#intel-bhi]_, an RSB underflow could be used for an
> +intra-mode BTI attack.  This is mitigated by clearing the BHB on
> +kernel entry.
> +
> +However if the kernel uses retpolines instead of eIBRS, it needs to
> +disable RRSBA:
> +
> +* "Where software is using retpoline as a mitigation for BHI or
> +  intra-mode BTI, and the processor both enumerates RRSBA and
> +  enumerates RRSBA_DIS controls, it should disable this behavior. "
> +  [#intel-retpoline-rrsba]_

IIRC, not all CPUs which suffer RRSBA have the RRSBA_DIS_* controls.

But, I think that's enough nitpicking for now.  I really think some
Intel and AMD architects ought to weigh in too.

~Andrew

