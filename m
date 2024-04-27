Return-Path: <kvm+bounces-16091-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 080BD8B430A
	for <lists+kvm@lfdr.de>; Sat, 27 Apr 2024 02:10:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 476A0B22CF8
	for <lists+kvm@lfdr.de>; Sat, 27 Apr 2024 00:10:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3AFAD10E6;
	Sat, 27 Apr 2024 00:10:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="TNq03HK6"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2978A20ED
	for <kvm@vger.kernel.org>; Sat, 27 Apr 2024 00:10:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714176614; cv=none; b=psQ+uNjA3dUuyGQYkSg66q4uhBj7T2PFSPn87lFSRbXPedESSOZQqgql1pN2+ym5rG+ZtuCRRj3rq8KEdQCoMRZpp4WAtAVUmCdnWW/6zXQCXObYWbdzQYkFNp42+xDZMV6DmeJa0jbCFMvgcrV4Otkrf/h+ynYzrN3kdownG1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714176614; c=relaxed/simple;
	bh=yinP9IYiIbLDbM6oDFHQvj2nAf8OvdI9Q9sPTHiIpf0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=nVGbPMpMVqJvaOZ5jmCV/TT1q0Wxc++ZNK3bMT9W50soXRZAxQLEmzGL6uTHbB7D+HWUeqHRv6E8uu1I0n+6+y1EM2ntPcEr/1ZOtNn2S2AQc5nWCOYzHX/O9lLaZanI2QZmhfMxmN3vMNyNjkQA6IycANQBBSifZcy6pNcB2+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=TNq03HK6; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-1eb48c26d14so2140635ad.1
        for <kvm@vger.kernel.org>; Fri, 26 Apr 2024 17:10:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1714176612; x=1714781412; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=pX3e6V8dfSE3Gfut3DvSdpkoJdELEXC0BtcZAcuIozM=;
        b=TNq03HK6kSZdc9/5Tb4XtmWpxQoVa2I+AE/c8/xhhRbNvuyref+5AiU46iXNDmWgYR
         c/5zzQV207UtoN7+QarQhMNGhZx9rHLdqfpCxLUM/xBn9Dh2vizqt6bBkTRSF8aZjzYh
         iCrHq9BTZenpLflPCDo4KJV5Ju/f7zVc6O4ddZLfnaSheHL7jxJFKT/NZLH0eKN3h8K1
         QgeLiyS37/18dm60OkKVIhrNyYxq3yyd7w7bMzhCAfl/GU3jT8XGagPCWTFWF+lnWzYC
         fpYnmSz5nVINcHZl67G2gcB1iKOBcEI9nbHikBBEOSxhpQlhztjBxpU+xffGnBcKyWRX
         O0HQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714176612; x=1714781412;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pX3e6V8dfSE3Gfut3DvSdpkoJdELEXC0BtcZAcuIozM=;
        b=LGbMgxIqhRq9WdXCh0I9FEpxlIAIFA9gqXdFUPIJ7pqvOi8DuoVOuSlQYC23+mtmq7
         IBLAzJ94C/HiGsD8WZxlMKndYuAhoUsV7Xnusyg8zyVTtZjXrLd3fIqG1ynTAVbe2x9F
         VRO4EI3zYfkNs54HjIZ7gKtbtfL1lo0rDUX/Q3iN6vq21cWkwbvmgydzc6ZGDdpI5yLG
         vFPe6wiR3YIPBricYmAAw2X1xtTl9xmqKCrp4S/Lx5UWkq1QbgYjKI1ViZbbY9evx/O4
         nq5HJvj7dabWZ09Hpwn2VKi+tC1weaqBHmgVontRhgqEYyyNBW3QBYZsTfOz/IPFlSp/
         M1pg==
X-Gm-Message-State: AOJu0YxNWw4rKWL4InHD+wbzXFCuw6mdfNynarsE8l/h734eumvuHBcf
	WC62k/2BYlNtzlbOqXUNkdoZNKmfuPZozFPXgMcuOOQpsFquDpELMpzS6y4OZbIY4qEpelTpoFb
	wJg==
X-Google-Smtp-Source: AGHT+IGeE+8TCHmYAm9ZGbpmSgEKJqEs1Jp1O3g0e+nnHHLhKIoKgjH9RHf12yfFHhvL2WEZcXN4ybRfODI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:d4c1:b0:1e5:5c69:fcd7 with SMTP id
 o1-20020a170902d4c100b001e55c69fcd7mr67795plg.5.1714176612367; Fri, 26 Apr
 2024 17:10:12 -0700 (PDT)
Date: Fri, 26 Apr 2024 17:10:10 -0700
In-Reply-To: <20240426214633.myecxgh6ci3qshmi@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240421180122.1650812-1-michael.roth@amd.com>
 <20240421180122.1650812-22-michael.roth@amd.com> <ZimgrDQ_j2QTM6s5@google.com>
 <20240426173515.6pio42iqvjj2aeac@amd.com> <ZiwHFMfExfXvqDIr@google.com> <20240426214633.myecxgh6ci3qshmi@amd.com>
Message-ID: <ZixCYlKn5OYUFWEq@google.com>
Subject: Re: [PATCH v14 21/22] crypto: ccp: Add the SNP_{PAUSE,RESUME}_ATTESTATION
 commands
From: Sean Christopherson <seanjc@google.com>
To: Michael Roth <michael.roth@amd.com>
Cc: kvm@vger.kernel.org, linux-coco@lists.linux.dev, linux-mm@kvack.org, 
	linux-crypto@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org, 
	tglx@linutronix.de, mingo@redhat.com, jroedel@suse.de, 
	thomas.lendacky@amd.com, hpa@zytor.com, ardb@kernel.org, pbonzini@redhat.com, 
	vkuznets@redhat.com, jmattson@google.com, luto@kernel.org, 
	dave.hansen@linux.intel.com, slp@redhat.com, pgonda@google.com, 
	peterz@infradead.org, srinivas.pandruvada@linux.intel.com, 
	rientjes@google.com, dovmurik@linux.ibm.com, tobin@ibm.com, bp@alien8.de, 
	vbabka@suse.cz, kirill@shutemov.name, ak@linux.intel.com, tony.luck@intel.com, 
	sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com, 
	jarkko@kernel.org, ashish.kalra@amd.com, nikunj.dadhania@amd.com, 
	pankaj.gupta@amd.com, liam.merwick@oracle.com, Larry.Dewey@amd.com
Content-Type: text/plain; charset="us-ascii"

On Fri, Apr 26, 2024, Michael Roth wrote:
> On Fri, Apr 26, 2024 at 12:57:08PM -0700, Sean Christopherson wrote:
> > On Fri, Apr 26, 2024, Michael Roth wrote:
> > What is "management"?  I assume its some userspace daemon?
> 
> It could be a daemon depending on cloud provider, but the main example
> we have in mind is something more basic like virtee[1] being used to
> interactively perform an update at the command-line. E.g. you point it
> at the new VLEK, the new cert, and it will handle updating the certs at
> some known location and issuing the SNP_LOAD_VLEK command. With this
  ^^^^^^^^^^^^^^^^^^^
> interface, it can take the additional step of PAUSE'ing attestations
> before performing either update to keep the 2 actions in sync with the
> guest view.

...

> > without having to bounce through the kernel.  It doesn't even require a push
> > model, e.g. wrap/redirect the certs with a file that has a "pause" flag and a
> > sequence counter.
> 
> We could do something like flag the certificate file itself, it does
> sounds less painful than the above. But what defines that spec?

Whoever defines "some known location".  And it doesn't need to be a file wrapper,
e.g. put the cert in a directory along with a lock.  Actually, IIUC, there doesn't
even need to be a separate lock file.  I know very little about userspace programming,
but common sense and a quick search tells me that file locks are a solved problem.

E.g. it took me ~5 minutes of Googling to come up with this, which AFAICT does
exactly what you want.

touch ~/vlek.cert
(
  flock -e 200
  echo "Locked the cert, sleeping for 10 seconds"
  sleep 10
  echo "Igor, it's alive!!!!!!"
) 200< vlek.cert

touch ~/vlek.cert
(
  flock -s 201
  echo "Got me a shared lock, no updates for you!"
) 201< vlek.cert

