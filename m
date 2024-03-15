Return-Path: <kvm+bounces-11924-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 98EA687D2FF
	for <lists+kvm@lfdr.de>; Fri, 15 Mar 2024 18:47:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4F28F1F21C51
	for <lists+kvm@lfdr.de>; Fri, 15 Mar 2024 17:47:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C0D7E4CB4E;
	Fri, 15 Mar 2024 17:47:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="1YdX/KzY"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A734748CCC
	for <kvm@vger.kernel.org>; Fri, 15 Mar 2024 17:47:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710524823; cv=none; b=gE5wVhT0bswHwPZZIJTX4hkh1Wyw826JvWnA9DFnCtIsN3UDMvtrlXeuc4aEDkMTJyyF4i/EXf1KUYFzzFmZPsaCpYpPit0XV8Pa9gDrBXcr4i3tXXvHbj4mElIN8Ug0vRZ5zE3T7MWkMaD0cWe9/H/I+cTuUEV5cW45ZdzVjl4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710524823; c=relaxed/simple;
	bh=/VATxNCGRIQ+t2Yq92hcjSJ1f640xZQiEIYrQi7kJ5g=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=IuugKi4Zg4Raow2TMtdN9vcUzhNJXBhIDF+DGKIxsoHTXm/k+OidTLWScJE0iPVpayMv6Fitye2O1tzG5aiwXwGju/+h1XRSR/zcZTE2JU++xJKjGl8KuOgSyzpdszkJz2R007XBD4i0hgce3qlSPvon8cGCg/okhquNnsReJMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=1YdX/KzY; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-5e4df21f22dso1827922a12.0
        for <kvm@vger.kernel.org>; Fri, 15 Mar 2024 10:47:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1710524821; x=1711129621; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=qoOQA6+i8aQ8iwOhf3gL6irab1l/tuoND6d1PwnBTsI=;
        b=1YdX/KzYBPsf96DiZiX1X6W0dpdAXoqK8lIsUbflctSiZmjFgIdPro3Wx8zx0g7Cq2
         wLwqCyndp6ufFkIgNRwVUOivMPYpubc0cxXMJwzIX8bRQMLdGjCSEmPms5/W3Au4SvTE
         rPozzltMszYOeHDP6X119Czx6iRGRi+oomy2Tjkja9uwGis5ORxINrSkAjwc7XB9lBG5
         XttvhcigsrpQMU6nUY8eLWC2eG/OPuN4ycmMduclYO0Le8T6CNBYRDXPANSJb/iiQ6yX
         rulNIy19n/3Edrd7zDMcvfagnmVilwF5aoi2MHMByM8CZhLh68hMyU1LtE+xHcdRNAbw
         IRgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710524821; x=1711129621;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qoOQA6+i8aQ8iwOhf3gL6irab1l/tuoND6d1PwnBTsI=;
        b=bopNMP5wKdCJ08U1nIwoY3F5qeGCab2OOMh4iDCqy3eqXqyYOAeURpAh9Z8HwYZUcZ
         EIjzZRtmnB0VqF1TYo/gzDdp8CIBImv0sr4e+WHL6EnnK/Gua2reBQToNYMsWg5VtB/w
         7hB2Swj/KJ0I3PrYdVK0BVSub+h5qsvOsPm13eqfPJulhE3k4YhrvwoMhKFuojXMPehA
         kfRIWHtl6ZirywIHM11qO+C78DTJF6clyMdoStQEFd6I9XN4cObDQcusPZuqJgHe1Hbq
         BxX6Tr/K831Xhg8s9U1Dwlmt1UbLDVKn9kdhSqgBkS75UJXVaibhCO3i2txl4HbmlYij
         uFLw==
X-Forwarded-Encrypted: i=1; AJvYcCUYmLyXqGUeF2Avo4qlBofmmmYSozEv7nqHukCFOkVf+x1Tp3IAO7mvXoAHWTxAi6FTF5xM7uo1mdSGERSBbblqd9ip
X-Gm-Message-State: AOJu0YweJdEOUHOGffiBRj4mARbc0YNiSYToiwqBWSyBJE/i8OEnBCcq
	2t/FWuuir/zqerMoKo+dB1GvVqM0onznqxdcT+5LUxpYstmLbYXDKgGNl4VATarArO51y37KpBu
	Wqw==
X-Google-Smtp-Source: AGHT+IEjZSwIQ+dipSKjZhWcaHChKjGlI2nHepHgDdzzp1ICgIQdIah38p9pOvbGYl8oWV2EKIkbRnQvdLg=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:e903:0:b0:5dc:4a5f:a5ee with SMTP id
 i3-20020a63e903000000b005dc4a5fa5eemr18686pgh.1.1710524820939; Fri, 15 Mar
 2024 10:47:00 -0700 (PDT)
Date: Fri, 15 Mar 2024 10:46:59 -0700
In-Reply-To: <ZfR4UHsW_Y1xWFF-@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <8f64043a6c393c017347bf8954d92b84b58603ec.1708933498.git.isaku.yamahata@intel.com>
 <e6e8f585-b718-4f53-88f6-89832a1e4b9f@intel.com> <bd21a37560d4d0695425245658a68fcc2a43f0c0.camel@intel.com>
 <54ae3bbb-34dc-4b10-a14e-2af9e9240ef1@intel.com> <ZfR4UHsW_Y1xWFF-@google.com>
Message-ID: <ZfSJkwnC4LRCqQS9@google.com>
Subject: Re: [PATCH v19 007/130] x86/virt/tdx: Export SEAMCALL functions
From: Sean Christopherson <seanjc@google.com>
To: Dave Hansen <dave.hansen@intel.com>
Cc: Rick P Edgecombe <rick.p.edgecombe@intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Kai Huang <kai.huang@intel.com>, 
	Isaku Yamahata <isaku.yamahata@intel.com>, "x86@kernel.org" <x86@kernel.org>, 
	Tina Zhang <tina.zhang@intel.com>, Hang Yuan <hang.yuan@intel.com>, Bo2 Chen <chen.bo@intel.com>, 
	"sagis@google.com" <sagis@google.com>, "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>, 
	Erdem Aktas <erdemaktas@google.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>
Content-Type: text/plain; charset="us-ascii"

On Fri, Mar 15, 2024, Sean Christopherson wrote:
> So my feedback is to not worry about the exports, and instead focus on figuring
> out a way to make the generated code less bloated and easier to read/debug.

Oh, and please make it a collaborative, public effort.  I don't want to hear
crickets and then see v20 dropped with a completely new SEAMCALL scheme.

