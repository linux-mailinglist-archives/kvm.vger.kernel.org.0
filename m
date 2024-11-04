Return-Path: <kvm+bounces-30555-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 11F929BB84B
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2024 15:53:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 90C5B1F21FCB
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2024 14:53:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CBE2A1BBBDD;
	Mon,  4 Nov 2024 14:52:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=citrix.com header.i=@citrix.com header.b="mg0Sadq8"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AFFA1AD3E0
	for <kvm@vger.kernel.org>; Mon,  4 Nov 2024 14:52:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730731974; cv=none; b=uPMmjs9CYK/M0tSdD3PX3d0eu4NIR7Fq6AmQ19PqoHeKpPqJNHyvYRdJhOYt0UI0MPKGlbpLtaWXkkU1GekZYZ8eDrd8u9sbzSaNc+jkEtPAMi4/b1pXZInTQHRnn4HXmHt4hw0ZT/FzV7U/0R+R8OJLufDXbH6lnBichp/R5o8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730731974; c=relaxed/simple;
	bh=A+L77clO/jgNKTSswUmQ6XjD5os9WSM+Y+3NhJMuPE8=;
	h=Message-ID:Date:MIME-Version:To:Cc:References:Subject:From:
	 In-Reply-To:Content-Type; b=U2mHQjiwVAI1c/8broH02wpWhaOWG73QkOTMN//0p3+wpf/xT/yHuJpCtD3JwSMST3tmrpMBuxAvr7iKYJ/XHi4pmVva+kre5DiR8/M9kfdcDsfCndQMIMIppU5G9U9scBv0O79tEYPTHZ/4uDRThFUHN0UhMQYfpqwF3AhGwVQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=citrix.com; spf=pass smtp.mailfrom=cloud.com; dkim=pass (1024-bit key) header.d=citrix.com header.i=@citrix.com header.b=mg0Sadq8; arc=none smtp.client-ip=209.85.208.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=citrix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cloud.com
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-5ced377447bso1701071a12.1
        for <kvm@vger.kernel.org>; Mon, 04 Nov 2024 06:52:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=citrix.com; s=google; t=1730731970; x=1731336770; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:subject:references:cc:to:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=A+L77clO/jgNKTSswUmQ6XjD5os9WSM+Y+3NhJMuPE8=;
        b=mg0Sadq8peP6S0MnX3RJ30jguLz0oHDk+LeCf7EP8ote2kdBP0jMsCLxD+jQ9mTmiP
         EHdPWXkeft6HnHh4kW1wq4MCES/BsxqmfqIvYGefkWw3RY3nb4vWUVJxtS5H4+sm7+5z
         kDPE6UfxvzqZfB0ez6054Tz9UTozszBFygp+I=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730731970; x=1731336770;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:subject:references:cc:to:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=A+L77clO/jgNKTSswUmQ6XjD5os9WSM+Y+3NhJMuPE8=;
        b=eGfG7lpItCMOr6KQfsvTqJMyJMPKXcpsS+4xzazC/5fwYtSb/DJwnXzDIo2Bmk/TWd
         Zt94cM3YEfXZQ9Xg6dK2uLUmfOpSeYDx7qYs16ZW0tOqmpVisx6r4CA0BgbOVdKNaIVw
         9bie8Naf8dFhREvOm6G2rGBrDjsJSseeVwOy02xrJkK5qHqbys6TGXr6QAgqfMa0AZvq
         70NqM+l0Ofe45iHMde3EmvgtTf1+dAsxk31aj8w1vjUXj4C84UfUtMX+4CcGgfNrYAls
         OnNwu+3dHGfJ1zXg5yCdBysTAUUwiuibdyIHopdRfY6lZlPK8gr8UXkPI4rW0xapwSl+
         UlNw==
X-Forwarded-Encrypted: i=1; AJvYcCWH71YPcMtEL7Izs4UwU+KPUYoyYVUhUUJwMt+8FEZ4AayIEfl56jUpQX7mij4w1HA5JnU=@vger.kernel.org
X-Gm-Message-State: AOJu0YwADVlr/me+/+QYouMAZhX6dQ3nITHjB2p1oIB0N3sZkCew1s7l
	97+zk3r54GX5p3F+PLPtlJem7RxVI0RRcuCnmMp3BCPSiEphDioeg+FWhyzVnQY=
X-Google-Smtp-Source: AGHT+IFDoo4WXZsH1fvO8W9i5FbdAmpXIPw4/xweeTupoFAMkMnrTfdxoGCfyN+ozSaWXapAkjmu6w==
X-Received: by 2002:a05:6402:d05:b0:5c9:6fc1:6177 with SMTP id 4fb4d7f45d1cf-5cd54a84c8fmr14836198a12.11.1730731970469;
        Mon, 04 Nov 2024 06:52:50 -0800 (PST)
Received: from [10.125.226.166] ([185.25.67.249])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5cec86a4ef2sm2765279a12.3.2024.11.04.06.52.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Nov 2024 06:52:49 -0800 (PST)
Message-ID: <e9711ae1-b983-4f3e-89b4-513db62e4eef@citrix.com>
Date: Mon, 4 Nov 2024 14:52:48 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: amit.shah@amd.com
Cc: Babu.Moger@amd.com, David.Kaplan@amd.com, Sandipan.Das@amd.com,
 Thomas.Lendacky@amd.com, boris.ostrovsky@oracle.com, bp@alien8.de,
 corbet@lwn.net, daniel.sneddon@linux.intel.com, dave.hansen@linux.intel.com,
 hpa@zytor.com, jpoimboe@kernel.org, kai.huang@intel.com,
 kvm@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, mingo@redhat.com,
 pawan.kumar.gupta@linux.intel.com, pbonzini@redhat.com,
 peterz@infradead.org, seanjc@google.com, tglx@linutronix.de, x86@kernel.org
References: <c3fbf18a4ec015039388617ed899db98272cf181.camel@amd.com>
Subject: Re: [PATCH 1/2] x86: cpu/bugs: add support for AMD ERAPS feature
Content-Language: en-GB
From: Andrew Cooper <andrew.cooper3@citrix.com>
Autocrypt: addr=andrew.cooper3@citrix.com; keydata=
 xsFNBFLhNn8BEADVhE+Hb8i0GV6mihnnr/uiQQdPF8kUoFzCOPXkf7jQ5sLYeJa0cQi6Penp
 VtiFYznTairnVsN5J+ujSTIb+OlMSJUWV4opS7WVNnxHbFTPYZVQ3erv7NKc2iVizCRZ2Kxn
 srM1oPXWRic8BIAdYOKOloF2300SL/bIpeD+x7h3w9B/qez7nOin5NzkxgFoaUeIal12pXSR
 Q354FKFoy6Vh96gc4VRqte3jw8mPuJQpfws+Pb+swvSf/i1q1+1I4jsRQQh2m6OTADHIqg2E
 ofTYAEh7R5HfPx0EXoEDMdRjOeKn8+vvkAwhviWXTHlG3R1QkbE5M/oywnZ83udJmi+lxjJ5
 YhQ5IzomvJ16H0Bq+TLyVLO/VRksp1VR9HxCzItLNCS8PdpYYz5TC204ViycobYU65WMpzWe
 LFAGn8jSS25XIpqv0Y9k87dLbctKKA14Ifw2kq5OIVu2FuX+3i446JOa2vpCI9GcjCzi3oHV
 e00bzYiHMIl0FICrNJU0Kjho8pdo0m2uxkn6SYEpogAy9pnatUlO+erL4LqFUO7GXSdBRbw5
 gNt25XTLdSFuZtMxkY3tq8MFss5QnjhehCVPEpE6y9ZjI4XB8ad1G4oBHVGK5LMsvg22PfMJ
 ISWFSHoF/B5+lHkCKWkFxZ0gZn33ju5n6/FOdEx4B8cMJt+cWwARAQABzSlBbmRyZXcgQ29v
 cGVyIDxhbmRyZXcuY29vcGVyM0BjaXRyaXguY29tPsLBegQTAQgAJAIbAwULCQgHAwUVCgkI
 CwUWAgMBAAIeAQIXgAUCWKD95wIZAQAKCRBlw/kGpdefoHbdD/9AIoR3k6fKl+RFiFpyAhvO
 59ttDFI7nIAnlYngev2XUR3acFElJATHSDO0ju+hqWqAb8kVijXLops0gOfqt3VPZq9cuHlh
 IMDquatGLzAadfFx2eQYIYT+FYuMoPZy/aTUazmJIDVxP7L383grjIkn+7tAv+qeDfE+txL4
 SAm1UHNvmdfgL2/lcmL3xRh7sub3nJilM93RWX1Pe5LBSDXO45uzCGEdst6uSlzYR/MEr+5Z
 JQQ32JV64zwvf/aKaagSQSQMYNX9JFgfZ3TKWC1KJQbX5ssoX/5hNLqxMcZV3TN7kU8I3kjK
 mPec9+1nECOjjJSO/h4P0sBZyIUGfguwzhEeGf4sMCuSEM4xjCnwiBwftR17sr0spYcOpqET
 ZGcAmyYcNjy6CYadNCnfR40vhhWuCfNCBzWnUW0lFoo12wb0YnzoOLjvfD6OL3JjIUJNOmJy
 RCsJ5IA/Iz33RhSVRmROu+TztwuThClw63g7+hoyewv7BemKyuU6FTVhjjW+XUWmS/FzknSi
 dAG+insr0746cTPpSkGl3KAXeWDGJzve7/SBBfyznWCMGaf8E2P1oOdIZRxHgWj0zNr1+ooF
 /PzgLPiCI4OMUttTlEKChgbUTQ+5o0P080JojqfXwbPAyumbaYcQNiH1/xYbJdOFSiBv9rpt
 TQTBLzDKXok86M7BTQRS4TZ/ARAAkgqudHsp+hd82UVkvgnlqZjzz2vyrYfz7bkPtXaGb9H4
 Rfo7mQsEQavEBdWWjbga6eMnDqtu+FC+qeTGYebToxEyp2lKDSoAsvt8w82tIlP/EbmRbDVn
 7bhjBlfRcFjVYw8uVDPptT0TV47vpoCVkTwcyb6OltJrvg/QzV9f07DJswuda1JH3/qvYu0p
 vjPnYvCq4NsqY2XSdAJ02HrdYPFtNyPEntu1n1KK+gJrstjtw7KsZ4ygXYrsm/oCBiVW/OgU
 g/XIlGErkrxe4vQvJyVwg6YH653YTX5hLLUEL1NS4TCo47RP+wi6y+TnuAL36UtK/uFyEuPy
 wwrDVcC4cIFhYSfsO0BumEI65yu7a8aHbGfq2lW251UcoU48Z27ZUUZd2Dr6O/n8poQHbaTd
 6bJJSjzGGHZVbRP9UQ3lkmkmc0+XCHmj5WhwNNYjgbbmML7y0fsJT5RgvefAIFfHBg7fTY/i
 kBEimoUsTEQz+N4hbKwo1hULfVxDJStE4sbPhjbsPCrlXf6W9CxSyQ0qmZ2bXsLQYRj2xqd1
 bpA+1o1j2N4/au1R/uSiUFjewJdT/LX1EklKDcQwpk06Af/N7VZtSfEJeRV04unbsKVXWZAk
 uAJyDDKN99ziC0Wz5kcPyVD1HNf8bgaqGDzrv3TfYjwqayRFcMf7xJaL9xXedMcAEQEAAcLB
 XwQYAQgACQUCUuE2fwIbDAAKCRBlw/kGpdefoG4XEACD1Qf/er8EA7g23HMxYWd3FXHThrVQ
 HgiGdk5Yh632vjOm9L4sd/GCEACVQKjsu98e8o3ysitFlznEns5EAAXEbITrgKWXDDUWGYxd
 pnjj2u+GkVdsOAGk0kxczX6s+VRBhpbBI2PWnOsRJgU2n10PZ3mZD4Xu9kU2IXYmuW+e5KCA
 vTArRUdCrAtIa1k01sPipPPw6dfxx2e5asy21YOytzxuWFfJTGnVxZZSCyLUO83sh6OZhJkk
 b9rxL9wPmpN/t2IPaEKoAc0FTQZS36wAMOXkBh24PQ9gaLJvfPKpNzGD8XWR5HHF0NLIJhgg
 4ZlEXQ2fVp3XrtocHqhu4UZR4koCijgB8sB7Tb0GCpwK+C4UePdFLfhKyRdSXuvY3AHJd4CP
 4JzW0Bzq/WXY3XMOzUTYApGQpnUpdOmuQSfpV9MQO+/jo7r6yPbxT7CwRS5dcQPzUiuHLK9i
 nvjREdh84qycnx0/6dDroYhp0DFv4udxuAvt1h4wGwTPRQZerSm4xaYegEFusyhbZrI0U9tJ
 B8WrhBLXDiYlyJT6zOV2yZFuW47VrLsjYnHwn27hmxTC/7tvG3euCklmkn9Sl9IAKFu29RSo
 d5bD8kMSCYsTqtTfT6W4A3qHGvIDta3ptLYpIAOD2sY3GYq2nf3Bbzx81wZK14JdDDHUX2Rs
 6+ahAA==
In-Reply-To: <c3fbf18a4ec015039388617ed899db98272cf181.camel@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

> Unfortunately, that's all we have right now in the official
> documentation.
>
> I've put up some notes in
> https://amitshah.net/2024/11/eraps-reduces-software-tax-for-hardware-bugs/

I appreciate the attempt to get a few details out, but this is very
confused on bunch of details.

Most importantly, you've described Intel RSB underflows, but named it
AMD BTC.

"Retbleed" is two totally different things.   I begged the discoverers
to give it two names, and I also begged the x86 maintainers to not alias
them in Linux's view of the world, but alas.

AMD's BTC comes from a bad branch type prediction, and a late resteer
from the ret uop executing.   It has nothing to do with RAS/RSB
underflow conditions.

~Andrew

