Return-Path: <kvm+bounces-63430-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 9961AC668DF
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 00:29:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 7DDE34E18BC
	for <lists+kvm@lfdr.de>; Mon, 17 Nov 2025 23:29:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A66C30DD30;
	Mon, 17 Nov 2025 23:29:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KBKmvsRm";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="HtlAYLjG"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-inbound-delivery-1.mimecast.com (us-smtp-inbound-delivery-1.mimecast.com [170.10.132.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF83D30DD2A
	for <kvm@vger.kernel.org>; Mon, 17 Nov 2025 23:29:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.132.61
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763422190; cv=none; b=VQYCIRTPxeFeXPCe/Tdq6FGlzADmrDEWODTjxkZ9N/UkVZvqrUYPnF1Pm9ACsrs2A3T2XaSujllgJMbyNNoFpClrIklTdYDzjvt9JhmlfO1ufBw1Rhzg5rmaAAKGu7Kyn7a2h2VbwYYYHEdy1B1Uyr1bYU2R5bMxMkJHJtqgAEQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763422190; c=relaxed/simple;
	bh=bkPXYP2kx9/yyMtwm/qyBxA2lGPazdEHS6YP4CDLRLs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=o0dRNxsN3wzB/KwupXSdfuLBVqoSEAmU/IVYYF8Svs4XbcAaETYwK17eNu4rIZb4XNfN23oNlJW9O1r9mOQyUC9lbvtWiOC43j4hhr0PIiWooIxJ3AP3FWLI6dDphcTabBY6EMGWvgzYg8Dg7Emfcon9lZT10OzqiJIVz4QleX8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KBKmvsRm; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=HtlAYLjG; arc=none smtp.client-ip=170.10.132.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1763422181;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=bkPXYP2kx9/yyMtwm/qyBxA2lGPazdEHS6YP4CDLRLs=;
	b=KBKmvsRma/ZYAVikDzicn2MhT1eHX6LqQrtupAraAVWh9F2kIXZdAPWq83K0FPH9STCLNm
	PG2nC2Ps+Ve5G77KRNUcd2qbk4WKOGDE06RxsXq5uSY85tWMrKL4BXSAZwCq7IKvxK4nGt
	BZQxa9QfhqOFHD+NEtOhF9L+NyG1/eg=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-680-XgK7YzhKP7aqSbqFnCIkcw-1; Mon, 17 Nov 2025 18:29:38 -0500
X-MC-Unique: XgK7YzhKP7aqSbqFnCIkcw-1
X-Mimecast-MFC-AGG-ID: XgK7YzhKP7aqSbqFnCIkcw_1763422172
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-42b2ad29140so2220533f8f.0
        for <kvm@vger.kernel.org>; Mon, 17 Nov 2025 15:29:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1763422172; x=1764026972; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=bkPXYP2kx9/yyMtwm/qyBxA2lGPazdEHS6YP4CDLRLs=;
        b=HtlAYLjG0kiukeLaer/SM8YCAlpT8gavvqtT7DuTAD5N93IIQiu+sju3Cek+MTGlPq
         4y70Qexd0tvGFkZpG3CgqPNZ+ecO1vm5f27GpGYBksQxKDoWV091djtxWf1WeCCwzfLM
         oibCOFUEuDYU2CpJfyfGJvBzC4y4kR85kb5lwPc22i/bX1ja4WE8E3Nz08UKappfF+Oc
         anim5VijiXS53yibqGwbMyPcTOt3UkuoiGbvak6Dii3vx3Xojoz6LUCVgHSuvjrZWRb4
         EDJ2nk7FaN0CJNGK+Rmipx+NbZW2IU++lowqgGMx6hKfouYOQMwqZQKA/jBdMwKY0pxF
         A8hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763422172; x=1764026972;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bkPXYP2kx9/yyMtwm/qyBxA2lGPazdEHS6YP4CDLRLs=;
        b=h8wzoUo6jk3xSyiBKM+WBhYz8joa5weNlPnD6Bj9BG1g/t/3oet/T3hOFCSZATrIb2
         Ryd/bovWaXEYkI+MW0R9IWXYIDd2/ZAPf8U0QW2p6O3KkbCKM/qZGvKvyerY4tWAO/ia
         XxDUPRnRcrv/8N4+Df4qWew4XIK6YLRn0orba6Hc7PTJJ1qYTKFvSuEcGXlQ7TVmnYzf
         Zvya88g3OlyDUG041sFjGBErnu9AemUZb0/ZKcoh1yksu/bsc5M2LzQHa3tQJQL6RJ2X
         Xq9QE+OeitUrBBD5DyZcZjX41Tfs38nvubkJn+gzqKik+66RdBEun6iDQHS85z7eRKMk
         NHrQ==
X-Forwarded-Encrypted: i=1; AJvYcCX5/GLcobIQaGTnKUasJW1OtfbgVZQNLrjH4c/pwZkNZS9yLGsLsc1H7ViMjhP4lnM/RIg=@vger.kernel.org
X-Gm-Message-State: AOJu0YyJjJ0oo9NWbT+KTv/yvZGbhotPPcRJdEp3qdBJ29VJO8jHmDrA
	yXyaFPDP+G72YGGPaVVSd7iygs8XA8dH1KnSD+pAlKOJBcWqBb1OoQ7nIX+wBruR6zklGzkjWd2
	CNZ9tNtjNqigbJUbfcGH9UBVBK4jlLg9ktgYt5xitMX7dSe0rj7kNm4kTlmdzOd+S66AE+0Guam
	wnpIQxHVB7Jw2aDY19OWtU0iRksPoF
X-Gm-Gg: ASbGncu4VLLLdTaTS7+a9DIz3/qP877OnNstpWe49nG/x9JCqdIvxTdA63fwV4D9cxw
	qe4hfVj7pA0zhWHUqy7IIwExsM4qN/b6tZA7mstTuDTXe0oEAuNyYtN/unEBY7hNORciRLJBD09
	Am9fyG0PPeATd8cA8Sk7WsJXrAn3Fz958NowPfUWDSCCIhXYbilmeEeZESWVu1zRzLi25oB0Yas
	afjJILEajrIaauif392Km3wc339wOS8NCGWvGYDWghD+BDqJuFXJBMmiyTFHZOSAGK1zQw=
X-Received: by 2002:a05:6000:2f83:b0:429:d3e9:694 with SMTP id ffacd0b85a97d-42b5932360dmr12702707f8f.5.1763422171942;
        Mon, 17 Nov 2025 15:29:31 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGhnUlvOHa1iFL3+WfCN4m7hL8e8VU9+w9pQP/qII9z1T6nsBIDPwU15+5B/5ky0jr2KyPwZLxo/OOzyJa7I2s=
X-Received: by 2002:a05:6000:2f83:b0:429:d3e9:694 with SMTP id
 ffacd0b85a97d-42b5932360dmr12702695f8f.5.1763422171638; Mon, 17 Nov 2025
 15:29:31 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251110180131.28264-1-chang.seok.bae@intel.com>
 <20251110180131.28264-8-chang.seok.bae@intel.com> <ebda0c03-b21e-48df-a885-8543882a3f3b@redhat.com>
 <aRPo2oxGGEG5LEWv@intel.com>
In-Reply-To: <aRPo2oxGGEG5LEWv@intel.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Tue, 18 Nov 2025 00:29:19 +0100
X-Gm-Features: AWmQ_blKLejt7XCcy-t3FDiFh-DfWGvsJYaexJvWoQKmnEdetXUT5N61iu96nfM
Message-ID: <CABgObfaF4YO0Zd5PKJ3u7kRB0engmsSywnzztV8BKm5yUyQdmQ@mail.gmail.com>
Subject: Re: [PATCH RFC v1 07/20] KVM: nVMX: Support the extended instruction
 info field
To: Chao Gao <chao.gao@intel.com>
Cc: "Chang S. Bae" <chang.seok.bae@intel.com>, kvm <kvm@vger.kernel.org>, 
	"Kernel Mailing List, Linux" <linux-kernel@vger.kernel.org>, Sean Christopherson <seanjc@google.com>, 
	Zhao Liu <zhao1.liu@intel.com>
Content-Type: text/plain; charset="UTF-8"

Il mer 12 nov 2025, 02:54 Chao Gao <chao.gao@intel.com> ha scritto:
>
> Shouldn't we check guest's capabilities rather than host's,
>
> i.e., guest_cpu_cap_has(X86_FEATURE_APX)?

As the manual says, you're free to use the extended field if
available, and it's faster.

Paolo


