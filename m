Return-Path: <kvm+bounces-73266-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id kLFFI+yCrmlfFQIAu9opvQ
	(envelope-from <kvm+bounces-73266-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 09 Mar 2026 09:21:00 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id ED3F82356EC
	for <lists+kvm@lfdr.de>; Mon, 09 Mar 2026 09:20:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 313ED302EE87
	for <lists+kvm@lfdr.de>; Mon,  9 Mar 2026 08:20:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 59CFB36D4FF;
	Mon,  9 Mar 2026 08:20:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZdaZvC1f";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="gjOQxjIs"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 695BC36AB51
	for <kvm@vger.kernel.org>; Mon,  9 Mar 2026 08:20:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=170.10.133.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773044442; cv=pass; b=PQz42dfo721d5+T6YpW2TZPx31oKA+OjtvbfesmOFWlsVHUhEq4SdujV2UqTGwkvos3lMzFRmL73ZejEOvjFMW062+9qaSnCBaum78vDJbhMWyVgDPWakiflyRTUkn3m01oJt47rZfDobU0j/VruvMJz0jzEiPLsig4dfv4+h50=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773044442; c=relaxed/simple;
	bh=YqhfFnF9zbBGAs+zR1B7KTjcj7uGJTVDO8i1NTSlXsE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=coNngy/esQ6RDkUcYbANN6PinDOpxdzkYY/6NRhFAb+anqMdSAOA8CUrG4ohOGUDlhK53AGGpVuV4oFht6RS/pi4kunwNIK1zNY/Is/eNkqlzfI2J7zXw2kaAFM1u6ZzMkROpZ+qU5PdLpJzQYFclWShMP57LP2EnIAx0jJ2+oI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZdaZvC1f; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=gjOQxjIs; arc=pass smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773044440;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=YqhfFnF9zbBGAs+zR1B7KTjcj7uGJTVDO8i1NTSlXsE=;
	b=ZdaZvC1flTtki8Skvi6ygtv9p3kHvPhHwMPSiCTx82mHivKG1ykS3bG+f+IojdfwveglAM
	QUSmrJDl4FpOMQYtgEQ5uJ2wA9bMvadUj2knmZonHjAMVtFHTMoeEESil625lxUrleOK0j
	z4mjrPfKkS3bLbMg+Nm/ZvueGpNrKRQ=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-226-b1VVU-Y7NQSiJLSRCMLcow-1; Mon, 09 Mar 2026 04:20:38 -0400
X-MC-Unique: b1VVU-Y7NQSiJLSRCMLcow-1
X-Mimecast-MFC-AGG-ID: b1VVU-Y7NQSiJLSRCMLcow_1773044437
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-439c2a0d821so4319189f8f.1
        for <kvm@vger.kernel.org>; Mon, 09 Mar 2026 01:20:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773044437; cv=none;
        d=google.com; s=arc-20240605;
        b=I+496XCLwiJdUY796N7xdJyzUcXwuAvDMtrkwunPrAybLXl8kSXG1CdSyL/B1VlGSJ
         l9U6h292ll8ahqWWpe5TFpgaEavHOj8Ce3y1+5husqDiZFBtW++2YVJZXWnYUx+xRO2Y
         +xPD27Bn6GAmbNnN5s+R+xcSL/PpvqSAN3lWmCevgU7QJjHk0d0TLPuOCYuAEE+zIrNW
         NzyRaw0LTNrMhZ9yF96ld29sh4qFJmQi5lLyCV72MU9Z4pMRHfRK6gTa5eZ93vplkvy9
         JPYpm9+2V4O9b+sG1zRuI+3GMU8hmV+R7+vGjF+NFNIQYTA/68791e40zMLFZsNdxyVb
         8KsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=YqhfFnF9zbBGAs+zR1B7KTjcj7uGJTVDO8i1NTSlXsE=;
        fh=2wx2p/nSo4w/IKNR147zRIgMyI4nBQCsGtZHB2Y6ui4=;
        b=aopAUyq57PE/2wAGTpJC7w2B47Ajcl51hwOq9oThxlgYRh/ZucTKBqM9f36gHBAGtD
         QDC6f4mb6tnBxhxcmPtZUTleDLlCS6aW+uMa8Qqge/+pjBV0+W81rJN7+5UnK6mdBpFE
         1yxJW+HPfXg1su7idiZTnx6JP7NoonuWsng2kIRAxeMzS0gGNRBMxTEbMKu7U6XFMDeb
         BghTJccInuMlXf8LGN4Q7yppGVQyNwOw6bpsu46yr3VJMxzQxGBIde9OBbJExvgHw0VT
         tQfT5ngnRermLYgHAE2oaNdDCBTN/VPRa5+Q3fFbhk7udKDqO+VIh59le7jRxshfgCVe
         2j3A==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1773044437; x=1773649237; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=YqhfFnF9zbBGAs+zR1B7KTjcj7uGJTVDO8i1NTSlXsE=;
        b=gjOQxjIszqdOepS7kTnJkTk1VxU9oCys2gz9juE5DkVN2wIdlF1HkrdCNdWW4fVk2j
         PVlCdmujeSiu/41q/V8UgcIjz09w3bOGJW5M7JvxiPWyq6qyn9TdzwTR6r2Ek/E8zHEW
         WnhsSbXSPEaJgXAHnsUpJpW7/ZlM7Xslfyo9/OQMJwc1lT4B3CVOVdeAD6gfoV1sVgC2
         7bBgTAJ8GZIKeCUvJ3nC3gLCECMlcl2KvZ6I358EU0/ahDJa1y4yhqdxUZOpLilgqKva
         ECKQ8vQHaGM5GDrifNB/MLyHInZZxaEsBg7wtNsk1uxONQCP6S4kQ69hQy+63EJLq6dt
         fOfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773044437; x=1773649237;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YqhfFnF9zbBGAs+zR1B7KTjcj7uGJTVDO8i1NTSlXsE=;
        b=vfZM91mEyPYy50k7X+we5Vlq1CZCqUQOHYgt4ZIRssLQsNXhT/ynHt8mHdNUh2D4+i
         t6m1ixq3zxj0eOY0a5v1v1EAYdpePtJlUL8DCKbre3xEUXu/+GIrewEuNjjFibYu5Krj
         XpaNdp1KlPFFh6c1TMYIuJoNfLlXWkW3ikYk5CVQBjosaf30FgK6XhZIXVIAq5ZAbRvd
         2yNZu2LVDfnKLtxDklEUvhtQSawQFRumr4UPmJWW9XbktofELmqfZF/0HJDqVOVErkMo
         ZOE5Qke03sqLEcI8AYhto/e+xQAjWOWNs4NHOa0w2OK6xrM6JLWK3t/+s/mrNJfyszk3
         ELkw==
X-Forwarded-Encrypted: i=1; AJvYcCW6u5hTZyoQx9tiap/z2j1YqVnSmWsIddhN9bmgVMykURyFpuh7zIK5Uhi599t8duVoYto=@vger.kernel.org
X-Gm-Message-State: AOJu0YwkrlLhi50MSwTadxq+vyptixrJ0EdA98I6T2/8cJ89U1teeVI0
	yjk1IhGKq3NqL0+c8+dGbw30SeQQUriLMqOrvPMuI0RdrHGjSQQXYZ0KywA99AUBSF+l9pdYgyU
	bBpUiRuvUcuXn1Img+RWld2HuRHVlU0Ctz8+xd0rCvwSMSx4vGLQvnvYy/lwBYkcXpf+cBHGc46
	SODSHiJ0vcDutmnwXpYxMYsNiJuKgJ
X-Gm-Gg: ATEYQzzALoOgFN9oL9hrdP8cN1kKFpCpyryFD139LO3tXLO2D8Ifup288Nwh6+veCxF
	edlAdwydbkgAQUOGoBBPG0x31N1v7Qg8qd+HowZ74BQRaeI2on4jVz24cX1IGO3NR3D6SP0xd3x
	YaR/VEebER5zFDlLNlkgnUIWUNsubnigVTDHpOJSlrc3Lm5yL0w/LjBjcfnCXqq4CGhSU2ILXu2
	49F8jVnUk+h4URhT+7R3w5sfTZG7kMxXEz6442LuWpXzCgyZtUDEZ8SH/FLoIs50mNqNJCxPgx6
	Zq7eMcs=
X-Received: by 2002:a05:6000:2404:b0:439:ac6b:dd3d with SMTP id ffacd0b85a97d-439da885f87mr18471789f8f.28.1773044436801;
        Mon, 09 Mar 2026 01:20:36 -0700 (PDT)
X-Received: by 2002:a05:6000:2404:b0:439:ac6b:dd3d with SMTP id
 ffacd0b85a97d-439da885f87mr18471756f8f.28.1773044436376; Mon, 09 Mar 2026
 01:20:36 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260306041125.45643-1-anshuman.khandual@arm.com>
 <aasZ5NNo7q9MRgzD@google.com> <abc4ed51-2129-4bed-a156-e0e9ec4e81c4@arm.com>
In-Reply-To: <abc4ed51-2129-4bed-a156-e0e9ec4e81c4@arm.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Mon, 9 Mar 2026 09:20:24 +0100
X-Gm-Features: AaiRm51yFI2kd1sNWa0bABUHZcLh8MIGpuzPgSldGIrFMLJxlwSMcj_YYIKg1LY
Message-ID: <CABgObfbK1AdWLLCmTpD56BFCM0j_ckUTta_DpaPYe3mmOf88wg@mail.gmail.com>
Subject: Re: [PATCH] KVM: Change [g|h]va_t as u64
To: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Sean Christopherson <seanjc@google.com>, 
	"Kernel Mailing List, Linux" <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: ED3F82356EC
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719,redhat.com:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_COUNT_FIVE(0.00)[5];
	FROM_NEQ_ENVFROM(0.00)[pbonzini@redhat.com,kvm@vger.kernel.org];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	MIME_TRACE(0.00)[0:+];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-0.962];
	RCPT_COUNT_THREE(0.00)[4];
	TAGGED_FROM(0.00)[bounces-73266-lists,kvm=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_ALL(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[redhat.com:+]
X-Rspamd-Action: no action

Il dom 8 mar 2026, 13:58 Anshuman Khandual <anshuman.khandual@arm.com>
ha scritto:
>
> On 06/03/26 11:46 PM, Sean Christopherson wrote:
> > On Fri, Mar 06, 2026, Anshuman Khandual wrote:
> >> Change both [g|h]va_t as u64 to be consistent with other address types.
> >
> > That's hilariously, blatantly wrong.
>
> Sorry did not understand how this is wrong. Both guest and host
> virtual address types should be be contained in u64 rather than
> 'unsigned long'. Did I miss something else here.

Virtual addresses are pointers and the pointer-sized integer type in
Linux is long.

You also didn't try compiling it on any architecture where this patch
would have made a difference.

Paolo

>


