Return-Path: <kvm+bounces-18535-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 239498D6278
	for <lists+kvm@lfdr.de>; Fri, 31 May 2024 15:11:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CC64B283320
	for <lists+kvm@lfdr.de>; Fri, 31 May 2024 13:11:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D26BF158A14;
	Fri, 31 May 2024 13:11:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="avsy/iqc"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82163158A12
	for <kvm@vger.kernel.org>; Fri, 31 May 2024 13:11:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717161062; cv=none; b=qwbQ+Z9MSpCGIR8qgmPHUtGvxlSqIQd6Hg7wIlVZcCF0YYXJO6D3XUzAUdsnjW9H/ifIfzZifvOu75A2CcKwW4yTRDVwsEY9SYmXIUvRlxuHc95hrhMbNgw2Vs25L3Q+ibpqUQXZMMGyCer/z3d5vvgSImQndtpShNapAP5vovg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717161062; c=relaxed/simple;
	bh=CqLmmdZ2wecXUVkHp+HXQRJLjMCpZYdCiUOYNmrEQ+o=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=UbNst+hTYpVmuXbuSQaSUoAgSiOVQkZo9aG3Leu42cPrCeXMKbXVj6bbHbSi89kxZm1yTndf2OWd3uS3NgZUkI3NBNA73Ns9SJXs6kzcyvaRYBgL9v6lOeQjYhYJ3Te8fdx3rRzxJJmz0wZA7iEtd1JhTxrlBnvFWXNog6CRtE4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=avsy/iqc; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1717161059;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CqLmmdZ2wecXUVkHp+HXQRJLjMCpZYdCiUOYNmrEQ+o=;
	b=avsy/iqcjV14RBcHBxlLBdgoRdsEUarlefrW9J6f5M4/LlKD+Ox9ECL/wANBTJwJ6hpHzs
	KekWSiv4iFQbdIwizRk4jowc7PYLbpvE6yEn6ApmtLuNdKnourO78CjplLyc3iSjPUxGMa
	+4+bu7D7HyLYPLDHfGhxa3YRvhr7t+0=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-335-V73oEPSiMxCwp2F3zY1wfA-1; Fri, 31 May 2024 09:10:57 -0400
X-MC-Unique: V73oEPSiMxCwp2F3zY1wfA-1
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-35dd0cc1a7bso528371f8f.1
        for <kvm@vger.kernel.org>; Fri, 31 May 2024 06:10:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717161057; x=1717765857;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CqLmmdZ2wecXUVkHp+HXQRJLjMCpZYdCiUOYNmrEQ+o=;
        b=JsBOM6Tw3AsiemHw04wI7b0KxT6VqlhMJzq38pMqkQ0RrLclQAN2A/oSgnHU9lbgXn
         9Jp1DTpFD8MTeNTb6rJsvkZ+Er39OgwGXGl8VjJSwGaakTEd2228GLAkPzyxAPHbjtb1
         FBN5sEgemSu7RVv8Tbs//WEjwN0cTDHYQYzAm1iU98HnD/2icClL446IKRh+v1NW4XTg
         2VsHw/ipmAMNpjlWXg38kcgpTXdbjKbGIkqN6w29iJqr9+RqMpfQQllDv6+OXYBaw3RI
         rdq92l1DnQmdEUeELcS1RJ/qm7ohniOH9eQEtNWW0Ew/FRm0udPMru4C5XOtTAgszsAZ
         kwNw==
X-Forwarded-Encrypted: i=1; AJvYcCV+M0NJ1vN+1R7dn5aBVuZvQMdw70J+G6jE2F2kl+zpr+aOixtZHVwdjjIIEXwvhzS7IG9J3An2ZWHyWm4wjVAp7eO6
X-Gm-Message-State: AOJu0Yyv8wgOy62a01upvNEg4hmSphe9EdS9yxiK6dcbQQQyKpGMWpLl
	SHfgQ/eBAWQrnMsjixJkMfFXy7ChpfK/Z+7X7kJV4Mw6hbXhWoNo0yqcZcJqMF+GXSa6Rjdn753
	8oQJoDT8/H7qUm24oDVUBr6/ti9qcKiUCp9m0/aA1z3+S2PYBIT/iMRoyK62biWOY9bH9iXLh2a
	ofGj36MlY302IKASRF7bg1CvdA
X-Received: by 2002:a5d:4bd1:0:b0:354:e0e8:33ea with SMTP id ffacd0b85a97d-35e0f37119cmr1303096f8f.66.1717161056772;
        Fri, 31 May 2024 06:10:56 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG3gzv4GfxGaWcm8XMVixs3+MtMYgeFKTzpnPkZZHcTWqGRUOOsjVrY6Fxl3SCwOqZe8dfStn6ygQ2HzwmiDVA=
X-Received: by 2002:a5d:4bd1:0:b0:354:e0e8:33ea with SMTP id
 ffacd0b85a97d-35e0f37119cmr1303068f8f.66.1717161056377; Fri, 31 May 2024
 06:10:56 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240501085210.2213060-1-michael.roth@amd.com>
 <20240501085210.2213060-10-michael.roth@amd.com> <84e8460d-f8e7-46d7-a274-90ea7aec2203@linux.intel.com>
 <CABgObfaXmMUYHEuK+D+2E9pybKMJqGZsKB033X1aOSQHSEqqVA@mail.gmail.com>
 <7d6a4320-89f5-48ce-95ff-54b00e7e9597@linux.intel.com> <rczrxq3lhqguarwh4cwxwa35j5riiagbilcw32oaxd7aqpyaq7@6bqrqn6ontba>
 <7da9c4a3-8597-44aa-a7ad-cc2bd2a85024@linux.intel.com> <CABgObfajCDkbDbK6-QyZABGTh=5rmE5q3ifvHfZD1A2Z+u0v3A@mail.gmail.com>
 <ZleJvmCawKqmpFIa@google.com> <3999aadf-92a8-43f9-8d9d-84aa47e7d1ae@linux.intel.com>
In-Reply-To: <3999aadf-92a8-43f9-8d9d-84aa47e7d1ae@linux.intel.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Fri, 31 May 2024 15:10:43 +0200
Message-ID: <CABgObfZZsJxQ5AKve+GYJiUB0cFc70qkDbvRB82KrvHvM0k3jg@mail.gmail.com>
Subject: Re: [PATCH v15 09/20] KVM: SEV: Add support to handle MSR based Page
 State Change VMGEXIT
To: Binbin Wu <binbin.wu@linux.intel.com>
Cc: Sean Christopherson <seanjc@google.com>, Michael Roth <michael.roth@amd.com>, kvm@vger.kernel.org, 
	linux-coco@lists.linux.dev, linux-mm@kvack.org, linux-crypto@vger.kernel.org, 
	x86@kernel.org, linux-kernel@vger.kernel.org, tglx@linutronix.de, 
	mingo@redhat.com, jroedel@suse.de, thomas.lendacky@amd.com, hpa@zytor.com, 
	ardb@kernel.org, vkuznets@redhat.com, jmattson@google.com, luto@kernel.org, 
	dave.hansen@linux.intel.com, slp@redhat.com, pgonda@google.com, 
	peterz@infradead.org, srinivas.pandruvada@linux.intel.com, 
	rientjes@google.com, dovmurik@linux.ibm.com, tobin@ibm.com, bp@alien8.de, 
	vbabka@suse.cz, kirill@shutemov.name, ak@linux.intel.com, tony.luck@intel.com, 
	sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com, 
	jarkko@kernel.org, ashish.kalra@amd.com, nikunj.dadhania@amd.com, 
	pankaj.gupta@amd.com, liam.merwick@oracle.com, 
	Brijesh Singh <brijesh.singh@amd.com>, Isaku Yamahata <isaku.yamahata@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, May 31, 2024 at 3:23=E2=80=AFAM Binbin Wu <binbin.wu@linux.intel.co=
m> wrote:
> About the chunk size, if it is too small, it will increase the cost of
> kernel/userspace context switches.
> Maybe 2MB?

Yeah, 2MB sounds right.

Paolo


