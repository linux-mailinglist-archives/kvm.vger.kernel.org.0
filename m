Return-Path: <kvm+bounces-41675-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1BF3AA6BEA4
	for <lists+kvm@lfdr.de>; Fri, 21 Mar 2025 16:50:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2BF2B3B97B8
	for <lists+kvm@lfdr.de>; Fri, 21 Mar 2025 15:48:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD42F22AE7E;
	Fri, 21 Mar 2025 15:48:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="GLBhk64z";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="UFncXx5/"
X-Original-To: kvm@vger.kernel.org
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 857711E571B;
	Fri, 21 Mar 2025 15:48:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742572095; cv=none; b=GdHclyVxIFmHNWj1u2pli2cDSBUrQyswNQy4dOlx7GNrK8lqebPCXiJBwwPHr7GA76o+cwVSHkSNBZL1bVf+r2lcDq71AB8/p61yhQW7hjMA8youM0Z5HQKWcIfr3gDkcjEyxq+W5+/e713LRCtp/t5h5/d2rdBc0QLWaQ0bGQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742572095; c=relaxed/simple;
	bh=9JQhu6M6KYhZ0EqQu+/68gIoogduvZZGmvXV2GHP9cQ=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=lTYC45S0n791nopA0eSo0e+jHgIxnm5lxnmZW1Iqb7tIQGdMWjrY57f3hT/sOKZPYH5bnQkJkreCyTHXv9DW2hgUwZpc/wRcCK1nAp/wZHcII/BhrUHVx80Ta8xOi60CfdxxNpMYLpEisyd0D8xwiXI78Sj9537uNQH57H06550=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=GLBhk64z; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=UFncXx5/; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
From: Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1742572091;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ZjEhErUErnHD0iiYBat55UKlW6UWTjwCYEzjVU9xZq0=;
	b=GLBhk64zhunxroRwwL/YpII4sQpNxVbQeEIPNpX5yVBVzjQhcf/HBbttx8INXOug4Sbn/j
	qXGO+xPu434dltXA3MZbz4d7sKdLlGN0mBoRweHc9IK0LI4WKkE4x50/8UX7oxXcrtTYrC
	2GXtGYLNFrj4M4ZE8coz7wf42AOAHkwcNc0FiOPLyh6VK2TduuQ01Jnu9KC6lM6fseALKW
	cMSCc4/SLBbg7Gxj769w/1XvlkT3PjrZvjEItzhyeDMLJcGrmR2YFUQS995SVCX6gCWTnd
	pMjuf0k8ttdjmMrKzwX3MgfC49gt8DNTIM0NE4cKk33vevUP7FhBnnVchCPyAQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1742572091;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ZjEhErUErnHD0iiYBat55UKlW6UWTjwCYEzjVU9xZq0=;
	b=UFncXx5/oLYsX9LqunOdmW0y9ZLph57DkGM+eT0oJfzyTOdmp/bXG5dYgj5yb5ugEFRiRb
	WWHXjHkUWkDDH8DA==
To: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>, linux-kernel@vger.kernel.org
Cc: bp@alien8.de, mingo@redhat.com, dave.hansen@linux.intel.com,
 Thomas.Lendacky@amd.com, nikunj@amd.com, Santosh.Shukla@amd.com,
 Vasant.Hegde@amd.com, Suravee.Suthikulpanit@amd.com, David.Kaplan@amd.com,
 x86@kernel.org, hpa@zytor.com, peterz@infradead.org, seanjc@google.com,
 pbonzini@redhat.com, kvm@vger.kernel.org, kirill.shutemov@linux.intel.com,
 huibo.wang@amd.com, naveen.rao@amd.com
Subject: Re: [RFC v2 14/17] x86/apic: Add kexec support for Secure AVIC
In-Reply-To: <20250226090525.231882-15-Neeraj.Upadhyay@amd.com>
References: <20250226090525.231882-1-Neeraj.Upadhyay@amd.com>
 <20250226090525.231882-15-Neeraj.Upadhyay@amd.com>
Date: Fri, 21 Mar 2025 16:48:11 +0100
Message-ID: <87a59e2xms.ffs@tglx>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

On Wed, Feb 26 2025 at 14:35, Neeraj Upadhyay wrote:
>  
> +/*
> + * Unregister GPA of the Secure AVIC backing page.
> + *
> + * @apic_id: APIC ID of the vCPU. Use -1ULL for the current vCPU

Yes, -1ULL is really a sensible value - NOT. Ever thought about
signed/unsigned?

> + *           doing the call.

How would this function ever make sense to be invoked from a remote CPU?

> + * On success, returns previously registered GPA of the Secure AVIC
> + * backing page in gpa arg.

Please use proper kernel-doc formatting and not some made up thing which
looks like it.

Thanks,

        tglx

