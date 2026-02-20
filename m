Return-Path: <kvm+bounces-71428-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id yJK6CH/tmGk4OQMAu9opvQ
	(envelope-from <kvm+bounces-71428-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Sat, 21 Feb 2026 00:25:51 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 77BCE16B615
	for <lists+kvm@lfdr.de>; Sat, 21 Feb 2026 00:25:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 29F19303815D
	for <lists+kvm@lfdr.de>; Fri, 20 Feb 2026 23:25:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 72D59314A94;
	Fri, 20 Feb 2026 23:25:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="sqqchV1i"
X-Original-To: kvm@vger.kernel.org
Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91E2230F549
	for <kvm@vger.kernel.org>; Fri, 20 Feb 2026 23:25:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771629936; cv=none; b=rzwBe2gsl50APilTfKzP1n2IyN9DcPstfV+hEVod5tKIPfv06r3ACtAr8Fp1lj2W7faA8UZNsLnr9dWyIluCUoZvWv61Bi9gJbTjJoDktYXa8AERBhvnBpCxLueAuaX72d4Ry6cLW7Acdz/fHtRvuzTc8B0YsQb2ODiVXMVJ+NU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771629936; c=relaxed/simple;
	bh=eZDELe6eJSLDOKVIBoCOTcDUy23mVxZ3XJ5ZKuFn2GY=;
	h=MIME-Version:Date:Content-Type:From:Message-ID:Subject:To:Cc:
	 In-Reply-To:References; b=qa73uXiXWntJhuBt4HRRbaY5l9TzqSkGsImdbGkXOHKzVwC54ON4QLq+Wo3WLJootu/NpDDuCc4hrU4mNm4YIDOq8XAwNcuuN5P6zjcLonbz7GnZC3y8hsapIvUkuoaDewc5ZMuWfdAISxAl5LPK6qnLPc3Y4wgRWJPv7DB3kp4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=sqqchV1i; arc=none smtp.client-ip=91.218.175.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1771629923;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Df5uKMtIYBunSohID3U5RuNs4nSDHBd9eMc7kofn2fM=;
	b=sqqchV1iz3qjnMJyyZQ64JtmRzWpwwBnyeiYlfTT1YcTSg1c6NwBPlRWz3oMhOJqXFojwQ
	0bgRPHdsgqmme1hOLfi4bVif/8OS9acGYoUF8A2/77f5+hC6yP8AUKMv8gRFR3iw9AgQgf
	iu9K3l05UnBQN2dsEBjWchxa+YYgwMA=
Date: Fri, 20 Feb 2026 23:25:21 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "Yosry Ahmed" <yosry.ahmed@linux.dev>
Message-ID: <f67849d5dc11f19ab5835b6166e56d9a253d5ea2@linux.dev>
TLS-Required: No
Subject: Re: [PATCH v4 2/8] KVM: x86: nSVM: Cache and validate vmcb12 g_pat
To: "Jim Mattson" <jmattson@google.com>
Cc: "Sean Christopherson" <seanjc@google.com>, "Paolo Bonzini"
 <pbonzini@redhat.com>, "Thomas Gleixner" <tglx@kernel.org>, "Ingo Molnar"
 <mingo@redhat.com>, "Borislav Petkov" <bp@alien8.de>, "Dave Hansen"
 <dave.hansen@linux.intel.com>, x86@kernel.org, "H. Peter Anvin"
 <hpa@zytor.com>, "Shuah Khan" <shuah@kernel.org>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
In-Reply-To: <CALMp9eTNpSDkEgVBb81n_vQrd63Txg+gMBCGh-DAcN5yOuhLxQ@mail.gmail.com>
References: <20260212155905.3448571-1-jmattson@google.com>
 <20260212155905.3448571-3-jmattson@google.com>
 <y2c76qtfmwgy4ncypthcm25wedlapwknjnfyptu62qmlbdqa7k@udzmtcddsmwa>
 <CALMp9eTNpSDkEgVBb81n_vQrd63Txg+gMBCGh-DAcN5yOuhLxQ@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[linux.dev,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[linux.dev:s=key1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71428-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[13];
	DKIM_TRACE(0.00)[linux.dev:+];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[yosry.ahmed@linux.dev,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-0.999];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,linux.dev:mid,linux.dev:dkim]
X-Rspamd-Queue-Id: 77BCE16B615
X-Rspamd-Action: no action

February 21, 2026 at 12:26 AM, "Jim Mattson" <jmattson@google.com> wrote:
>=20
>=20On Thu, Feb 12, 2026 at 4:22 PM Yosry Ahmed <> wrote:
>=20
>=20>=20
>=20> @@ -2006,13 +2012,16 @@ static int svm_set_nested_state(struct kvm_=
vcpu *vcpu,
> >=20
>=20>  /*
> >  * Validate host state saved from before VMRUN (see
> >  - * nested_svm_check_permissions).
> >  + * nested_svm_check_permissions). Note that the g_pat field is not
> >  + * validated, because (a) it may have been clobbered by SMM before
> >  + * KVM_GET_NESTED_STATE, and (b) it is not loaded at emulated
> >  + * #VMEXIT.
> >=20
>=20>  (b) here means that svm_copy_vmrun_state() does not copy it to vmc=
b01,
> >  and the value is restored by KVM_SET_MSRS, right?
> >=20
>=20Actually, (b) refers to the open-coded block of assignments in
> nested_svm_vmexit() under the comment:
>=20
>=20 /*
>  * Restore processor state that had been saved in vmcb01
>  */
>

Yeah IIUC it's the same thing, we migrate them and copy them here to vmcb=
01 so that we can restore them in nested_svm_vmexit().

