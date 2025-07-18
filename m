Return-Path: <kvm+bounces-52829-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D852FB0995D
	for <lists+kvm@lfdr.de>; Fri, 18 Jul 2025 03:45:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 640DB1C40738
	for <lists+kvm@lfdr.de>; Fri, 18 Jul 2025 01:46:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 21931194A60;
	Fri, 18 Jul 2025 01:45:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NPjaJbOn"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com [209.85.215.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04CC118035;
	Fri, 18 Jul 2025 01:45:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752803144; cv=none; b=pyQVzy9OrsI+GCoEe3mRV5/N8xM51DXESJHqKqQcFEQ+tpIfTyfrcp7p6DglGwdqlMuXiq1n8P0ng659LLaJqBRVK+tJ83U+8BFykg9zjnsfDwDC6VV6BKf//OUYF1YYoArNGxdIhPAmOGcXqqTJNboy+C5Ansn4r24p5Ec72aM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752803144; c=relaxed/simple;
	bh=0wr/vLhiQ6NijpB8b89SNn2skNX/Y2tfq43tondZBFk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=uv+DYC16rq9i51v3xKY4sjGaGA+QfK0nvIOkSnhwSt45YX0DKyzH/6pmZ5QTO9mIsuOkeGI+soJ/taSVhfpBuENXrpPBuHVt1L7pWr5Nzutc67+xVXPig5qyAB//+X/WFBgUPJ2MRvtJ86CvNWKk6zoyITiSxmyrobrlM/v2Reo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NPjaJbOn; arc=none smtp.client-ip=209.85.215.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f173.google.com with SMTP id 41be03b00d2f7-b3be5c0eb99so1255565a12.1;
        Thu, 17 Jul 2025 18:45:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1752803141; x=1753407941; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XFB0B4sascT2h9KQrD7NJ165fH7q5rHReq8oprgy2qU=;
        b=NPjaJbOnJmKCNLdxqQqNfZSvq3WXnaf5AGCJelMzppSDulQzm1DeBOXvw6BPGy1hnS
         /kUQkeMncp4a2oXn8AzNIMUxBjDYsM+y5/l41Lbb7ZoNPFmqyspioHPYudXh9cffX1CT
         /18EiV+IQq1CAP4JfY0OHf5SX5nIgrj2+emc88K4SISGHO+0CRSHjiIwyGv7ugekyOrz
         Hsd/aDdNo3QwagyZINGfL0nMWTxsSjBFJ6q8bOLoXx3KDhLbX86TjAR25wcRkXDuauUp
         PLiA20T53f+ZgNXEtIsrcyiKPpEihlH33IN+MFkHoAi/kred453jlTju5rIDWbi/fARd
         5C/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752803141; x=1753407941;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XFB0B4sascT2h9KQrD7NJ165fH7q5rHReq8oprgy2qU=;
        b=ha40hE2/NtcxsjD8Gn9ySY3uInta82qftJV1a3G1QF/qKn6eg0tLGOCDYjhvwWh4wf
         Bm6IN1WQMNFmIjQbu9OejNIekhfNXq6Aa0Eo4wa9ZWSLENZ7Ozdk8ce8RKVcpTQuK2lG
         lUacalW1339CwBl97SA2doDVtzpNTSJLjEP+L9O18rlK46eHB/11Z/oL9986gwkiizdx
         klV49Cp394uyXyakN3AHrXkYbFMVrpgVa+OVBFg3MfWTh1h24ebDF06Nz1VCnPSI510r
         j9LbkTXxP6c8Tx2VByoIAX6XnFJisnBN8Vqg2maOrPdr9ncopPLsrP8P/PaJGqQVwxzw
         8k1w==
X-Forwarded-Encrypted: i=1; AJvYcCUXTgYSsX/xWhBT8kwLRfz5ZTxf7BImho7Oj5b7bFSVdlAxZapM7WObopc7RXfIlvXz/P0=@vger.kernel.org
X-Gm-Message-State: AOJu0YyMpEgxZ1zDQT4/K8USWV0fbcB0L5NzjJMXgGnC3xTb23hsubar
	gSqpC8f4k6C/L4SJM8pckatCtsLSAEv60Lkif0GRKSsXnHYoJEJ7EJNewPeNizmwFqX8fykAMyt
	LKRwv5rc+nMd1bVuC2Wqqo5go+8Q0+KY=
X-Gm-Gg: ASbGncuUoyeBNRKqhcF8q8o6Vjk8bkpMUdF3JUVregchf7Xczx9GH3G2kqlck17Cb22
	A/WlJxb/i5pJO9CLx6bM6A//0vnrfU8F+Ou0T/DYeaT+7SgXcKtNrQYQMsc9hdjLla3L8M9DfZ3
	rvZLCcqb4K+GGbf6zxEh6x2XgR/BUojOs7P2CIyL4j6hUrT4DAoFuyxTYydbwOirlTVCUooFbct
	mYK
X-Google-Smtp-Source: AGHT+IEJY08DSgDpcVBVWCiOM4YXR16RxEMJpSpYeJJu6a9bg/YiOcnZQ32P//Hrz6wfYmoyvSjGpmtju6CTbTfXjt8=
X-Received: by 2002:a17:90b:1810:b0:313:271a:af56 with SMTP id
 98e67ed59e1d1-31cc2608a57mr1301164a91.30.1752803141053; Thu, 17 Jul 2025
 18:45:41 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250709033242.267892-1-Neeraj.Upadhyay@amd.com> <20250709033242.267892-25-Neeraj.Upadhyay@amd.com>
In-Reply-To: <20250709033242.267892-25-Neeraj.Upadhyay@amd.com>
From: Tianyu Lan <ltykernel@gmail.com>
Date: Fri, 18 Jul 2025 09:45:05 +0800
X-Gm-Features: Ac12FXw-pxbYhghxKW3ky5r4WJn83Jm_TxQRSr21pyiYFmGrcxxWrUxKdNEoICI
Message-ID: <CAMvTesDMsV=0Z-W5V9uOTM8WBjyqs0dMLxdEkjpVYFgR6Wojag@mail.gmail.com>
Subject: Re: [RFC PATCH v8 24/35] x86/apic: Add support to send IPI for Secure AVIC
To: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
Cc: linux-kernel@vger.kernel.org, bp@alien8.de, tglx@linutronix.de, 
	mingo@redhat.com, dave.hansen@linux.intel.com, Thomas.Lendacky@amd.com, 
	nikunj@amd.com, Santosh.Shukla@amd.com, Vasant.Hegde@amd.com, 
	Suravee.Suthikulpanit@amd.com, David.Kaplan@amd.com, x86@kernel.org, 
	hpa@zytor.com, peterz@infradead.org, seanjc@google.com, pbonzini@redhat.com, 
	kvm@vger.kernel.org, kirill.shutemov@linux.intel.com, huibo.wang@amd.com, 
	naveen.rao@amd.com, kai.huang@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 9, 2025 at 11:42=E2=80=AFAM Neeraj Upadhyay <Neeraj.Upadhyay@am=
d.com> wrote:
>
> With Secure AVIC only Self-IPI is accelerated. To handle all the
> other IPIs, add new callbacks for sending IPI. These callbacks write
> to the IRR of the target guest vCPU's APIC backing page and issue
> GHCB protocol MSR write event for the hypervisor to notify the
> target vCPU about the new interrupt request.
>
> For Secure AVIC GHCB APIC MSR writes, reuse GHCB msr handling code in
> vc_handle_msr() by exposing a sev-internal sev_es_ghcb_handle_msr().
>
> Co-developed-by: Kishon Vijay Abraham I <kvijayab@amd.com>
> Signed-off-by: Kishon Vijay Abraham I <kvijayab@amd.com>
> Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
> ---
> Changes since v7:
>  - No change.

Reviewed-by: Tianyu Lan <tiala@microsoft.com>
--=20
Thanks
Tianyu Lan

