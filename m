Return-Path: <kvm+bounces-40118-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7B08CA4F50C
	for <lists+kvm@lfdr.de>; Wed,  5 Mar 2025 04:01:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 982CE3A9CD9
	for <lists+kvm@lfdr.de>; Wed,  5 Mar 2025 03:01:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9D42515CD74;
	Wed,  5 Mar 2025 03:01:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="M2vR4jVe"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A7372E3373
	for <kvm@vger.kernel.org>; Wed,  5 Mar 2025 03:01:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741143691; cv=none; b=cbZIeD0YN5an/MVSWD4hzTBnxJGt0nPPfXkznt47s1F6AZUS+2rWN6u3OQfk7lN5yTcRoIMOwzIi59MmyS17dZrQnkXwfQYVVNxqNfyfZY2lqKeSQruKHJGFbyMcewhF+IguVEDi8foy8Obeyxw81KRfpAdsI31TwbkTBYMp+P0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741143691; c=relaxed/simple;
	bh=SQDr5ldeyrak0fqcgofevKyTUAamPcCphiDxThQmsj0=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=avIGKUPUxF9diD3ojGhD0fGDiM6rV1uTQXOjPLCLqmpjsHflvmZApwKwdIjob+5HS7zjeVcf0XHqhmSEDu0oTXCEEa5KCosyjHC9J+MW22DpfKDgOVuz4ZMYIWTHMwKCCkKfcIMpSiiPPPt820K/m0JkT+nE///h+LZlwq+Hwfg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=M2vR4jVe; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741143688;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LXFMmu1EgcReOCw6/NPEyCwNwAPUOuUmwhoOj3Bw9K4=;
	b=M2vR4jVe0gpvAHQSBptqcX+txSnLf0mxRPa58K6sUDEH313KX5DIpHmQj/F34dBC9Rw+5g
	HbHHTU+aF5bs0BRDIn48YHPnW3KSjoLUSobn7trI7WJCz3bjRalODBfTiVMSlco4gmDrfy
	Ttw6BPKl/QuOJWVcuzW5zr3FGemsbr4=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-635-oc5YkVCtM9-BrM11qjHK8g-1; Tue, 04 Mar 2025 22:01:27 -0500
X-MC-Unique: oc5YkVCtM9-BrM11qjHK8g-1
X-Mimecast-MFC-AGG-ID: oc5YkVCtM9-BrM11qjHK8g_1741143687
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-7c3c2610b41so438676985a.1
        for <kvm@vger.kernel.org>; Tue, 04 Mar 2025 19:01:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741143687; x=1741748487;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=LXFMmu1EgcReOCw6/NPEyCwNwAPUOuUmwhoOj3Bw9K4=;
        b=a32cRlkVvmjTSHyZ/FzeYWIekAr4nYCmq3zXuxfIlnpFTfQ4ueNrBkJl5OR5zdpSZ4
         nyeX2a7nEWRagE3BQefMQjJVSwZJF293lEjNWTCT9OlZpFfofvKLmMjFHBxzA1rWMKRs
         Sid34YNkktt7uNpKRTBlCb7TT/M1nMHr0yrGkYYSFDwxTr41yYnM3Cc+E5gyYF6zeD2Y
         KMkQQTaU8LeE+YFgBKvc/dYoF9IE2f3Q+CH0y9JK10JFOih3isPyJhAcfL0NfOYY9G4i
         q2O3dbgjChBCUnVbqvjwBX866ka3dq+E6If/kBMvlANdfY57P7EAbRb97eSlxBbWxXjC
         8MOQ==
X-Forwarded-Encrypted: i=1; AJvYcCVKN1pqR6NOmBfCXn2NwreBwo5XGQZPyMx+zHVm7WmX4lOhnx9z3Zf3CtV/rC+KqFIROBk=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx7bw5lSp1gJtwCZdAfRlxttfTH3EiZ1JNH0TerKtc02+P9HNt8
	RgHoO/TyHNf3OpW9tQUpbxAfpgcdl7+OO7ZQ/RXGlgIgb/jYxUnfqsB+5Jp/YiPV9/qdbcSU4hn
	/LkRsMpkywAzNsURV36Xr2N76TxPBASEwU81jrce+IJCvM6KmlQ==
X-Gm-Gg: ASbGncsJwtk+mEp0QNsL+8yl8vb9YkIRVhRR34MLYL2+q0U9pLJmrqGPoe2Jz/sTzzg
	2uQ+nn9L9XFtqzI8h4cCGeYGYMf8k7SbMib69K7UDwQYzyODyDlBAi4sGmn71UllP+SGGNtNc6N
	r60UYOB8ilqnUFqtk8E31DIehhXDTaJE+4zRhbpn4scssQrqKbdy9lSEDHXjTOOjQMWza6k9GvS
	b0WmNk4D0sphGucVHOK7rRGvXMvlp0xR2XdhNbNvS24d6bFswuLwOtWWrAfk4JI3DHLEexI6eUh
	nz4OGzM0RLL5muc=
X-Received: by 2002:a05:620a:8082:b0:7c0:7eab:64a1 with SMTP id af79cd13be357-7c3d8ef3013mr310968285a.48.1741143686736;
        Tue, 04 Mar 2025 19:01:26 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEiUQqBZbHKRH29Clw9QqtOwZBLjg2B9QS4anWF5COImXioekphqyo3RllkC40LZOUKPHUGWA==
X-Received: by 2002:a05:620a:8082:b0:7c0:7eab:64a1 with SMTP id af79cd13be357-7c3d8ef3013mr310963385a.48.1741143686408;
        Tue, 04 Mar 2025 19:01:26 -0800 (PST)
Received: from starship ([2607:fea8:fc01:8d8d:6adb:55ff:feaa:b156])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7c3c880f022sm246398085a.3.2025.03.04.19.01.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Mar 2025 19:01:26 -0800 (PST)
Message-ID: <6345e31c7973a2ec32b11ed54cede142a901044e.camel@redhat.com>
Subject: Re: [RFC PATCH 11/13] KVM: nSVM: Do not reset TLB_CONTROL in VMCB02
 on nested entry
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
 <pbonzini@redhat.com>,  kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Tue, 04 Mar 2025 22:01:25 -0500
In-Reply-To: <Z8YpxLONlmy91Eot@google.com>
References: <20250205182402.2147495-1-yosry.ahmed@linux.dev>
	 <20250205182402.2147495-12-yosry.ahmed@linux.dev>
	 <a70458e20e98da9cd6dd1d272cc16b71bfdd4842.camel@redhat.com>
	 <Z8YpxLONlmy91Eot@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Mon, 2025-03-03 at 22:14 +0000, Yosry Ahmed wrote:
> On Fri, Feb 28, 2025 at 09:17:52PM -0500, Maxim Levitsky wrote:
> > On Wed, 2025-02-05 at 18:24 +0000, Yosry Ahmed wrote:
> > > TLB_CONTROL is reset to TLB_CONTROL_DO_NOTHING on nested transitions to
> > > L2. This is unnecessary because it should always be
> > > TLB_CONTROL_DO_NOTHING at this point.
> > > 
> > > The flow for setting TLB_CONTROL is as follows:
> > > 1. In vcpu_enter_guest(), servicing a TLB flush request may set it to
> > > TLB_CONTROL_FLUSH_ASID in svm_flush_tlb_asid().
> > > 2. In svm_vcpu_run() -> pre_svm_run(), it may get upgraded to
> > > TLB_CONTROL_FLUSH_ALL_ASID when assigning a new ASID.
> > > 3. In svm_cpu_run(), it gets reset to TLB_CONTROL_DO_NOTHING after the
> > > guest is run.
> > > 
> > > Hence, TLB_CONTROL is reset after each run and there is no need to do it
> > > again on every nested transition to L2.
> > > 
> > > There is a TODO in nested_svm_transition_tlb_flush() about this reset
> > > crushing pending TLB flushes. Remove it, as the reset is not really
> > > crushing anything as explained above.
> > 
> > I am not sure that we don't crush a pending tlb request: 
> > 
> > svm_flush_tlb_asid can also be called by KVM_REQ_TLB_FLUSH
> > and set the flush request in both vmcbs, thus later the nested_svm_exit_tlb_flush
> > can crush this request.
> 
> How so?
> 
> nested_svm_exit_tlb_flush() makes a KVM_REQ_TLB_FLUSH_GUEST request.
> svm_flush_tlb_asid() is called when servicing KVM_REQ_TLB_* requests.

I am probably missing something but:

Suppose KVM_REQ_TLB_FLUSH is raised and then processed while ordinary L1 entry is happening,
but nested state is allocated.

(KVM_REQ_TLB_FLUSH can be raised anytime MMU wants a 'big hammer flush everything')

In this case svm_flush_tlb_all will call svm_flush_tlb_asid on both vmcbs (see patch 8),
and that will set TLB_CONTROL_FLUSH_ASID in both vmcbs.
In particular it will be set in vmcb02.

Later, maybe even hours later in theory, L1 issues VMRUN, we reach nested_vmcb02_prepare_control,
and crush the value (TLB_CONTROL_FLUSH_ASID) set in vmcb02.

I think that this is what the removed comment referred to.


Best regards,
	Maxim Levitsky

> 
> So svm_flush_tlb_asid() does not make a request in the sense of
> KVM_REQ_*, it sets TLB_CONTROL or invalidates the ASID, which is can
> more-or-less be described as "requesting" a TLB flush on VM-enter, but
> is not the same thing as KVM_REQ_TLB_FLUSH.
> 
> So I am not sure there are any requests being crushed here.
> 
> > But the patch itself does look OK to me, although I might be mistaken.
> > 
> > Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
> 
> Thanks!
> 
> > 
> > Best regards,
> > 	Maxim Levitsky



