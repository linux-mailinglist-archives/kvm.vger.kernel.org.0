Return-Path: <kvm+bounces-41485-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BF120A68D56
	for <lists+kvm@lfdr.de>; Wed, 19 Mar 2025 14:02:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2AA8816873F
	for <lists+kvm@lfdr.de>; Wed, 19 Mar 2025 13:02:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A3BB2512EF;
	Wed, 19 Mar 2025 13:02:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="boU5ka+t"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D57E7134BD
	for <kvm@vger.kernel.org>; Wed, 19 Mar 2025 13:02:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742389349; cv=none; b=Q7teJRPxYNewwNrcJAVUvatZ16W/JNtLgXLt/20LNyp+Pl1U6QjR3yuzcxZ4nwO4xZgMHqVFGbqBp5H2zRhiR+SlAiend3KLAE6vPKz1lAwZWS8WyggqDuttV3WpeKaHeun+5XpGl1z52TtSlFXyaFs2Uz1GdTejeEdqnDs1ZBw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742389349; c=relaxed/simple;
	bh=hjYKCzXkTNj7DEe6K/168WOuyg5Vvokvimor4gxXeCg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=RQ9A3uSyQPZos9ASP/ebBYEKQHy8U+zFYgJWMEtsmsNCXIPVzyEDrQj2FVQsrb7Ej4A9ZN3EWuan4RBbEHt1dp6Lr+79Eodh99veCQfXg+ul6aC19b/+73SMNOyF65e67vzwcjI3afw+uU3qwy0t+XeuUUwV7waKsy1Syx+ABtA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=boU5ka+t; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1742389346;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hjYKCzXkTNj7DEe6K/168WOuyg5Vvokvimor4gxXeCg=;
	b=boU5ka+tNdXnNBYD/gob+3SVVogzchzpiAT/9ITRPI/4qQITGH9jFZy/4htgWsMzxaYyH+
	8aLnW33LtCkEB82zB2/zBVLCxraaW8p3/ZSulQfrqIjGUcYvdR9YLNp376jJ581fpoMybE
	xd+FWHWdt5Q6DCjoZRwsjiLJsOHkTCo=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-677-mHIxfZBiOyaubcznK-H3XA-1; Wed, 19 Mar 2025 09:02:25 -0400
X-MC-Unique: mHIxfZBiOyaubcznK-H3XA-1
X-Mimecast-MFC-AGG-ID: mHIxfZBiOyaubcznK-H3XA_1742389341
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-39131f2bbe5so2807839f8f.3
        for <kvm@vger.kernel.org>; Wed, 19 Mar 2025 06:02:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742389341; x=1742994141;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hjYKCzXkTNj7DEe6K/168WOuyg5Vvokvimor4gxXeCg=;
        b=iJhZ4v/gkLFyd6BlAlENfuFdZ2zmSyLgOqVMTNVStPfLEEuB93tmNH6Ziktwdz19ll
         GPxIJVzOBfjF6tGKzmX8wCx/qln+OKBVjNx92nI2LZXYrBVrNDtXXXYzDl92xMStKfFp
         Zi7v60eu+0phfQk6lTnMA8As8snQW1gcfz1cwObQGxniK7P245ipBEEoqCNlVeTJiBFs
         ucWvb/lJTu55uTwI3SrOEDP6hcHPFqbAE5X6SUpdovBUBIF6hqLWKjYb01squ/wPMEPn
         6BCYJ7ZYBCJxzErCdvTrW/0uw/l1TumWr/KmUWJvjrVCSZe7NNnnv0U85lXzNXQ8Ztj4
         TFdw==
X-Gm-Message-State: AOJu0YwFeQiDXY9Kd31oCKmqBMt95VkwaHfyHce/8oAnJ1tYbLNDZOiV
	p8lVDdl8a8HkhBI4+wjt5p0LpLaJdAkD2z8Bmw07oNDsP7W75RHsDDll0YJyU4Bfrda6SYqL2R9
	9MNAEIGJxKL/PXBTBsyj1Q1KvsyO2eZ8dfidW/edNnlOLxD9fOFEAPixs/inmWLLz7eXjEAcc5U
	hEx+3k9eAqMArpBCmjEdYBUYaWyxkDynuj
X-Gm-Gg: ASbGncvG/tcOTtMqpWy7ghq3nNAyMTr7ruR97D9Zs3fvBW7usoFjtwBfI58wQdr59NW
	/eX05IKOIsttt9tbXgwln6krDzOIHVMLSqUTzLuYF2jFw20ttujJTkrY2NNVFxbz5SlyHhjioGw
	==
X-Received: by 2002:a05:6000:154d:b0:391:2db0:2961 with SMTP id ffacd0b85a97d-39973b50772mr3127268f8f.38.1742389340950;
        Wed, 19 Mar 2025 06:02:20 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFD6HfFmmSP0cjkdSlhe7K0qb4m/uOtm3qySw4lyfLWCTKjI9y2oVrZxJTWh4ZUa1nmkABFImIaCl2RPU909rU=
X-Received: by 2002:a05:6000:154d:b0:391:2db0:2961 with SMTP id
 ffacd0b85a97d-39973b50772mr3127190f8f.38.1742389340432; Wed, 19 Mar 2025
 06:02:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250314161551.424804-1-imbrenda@linux.ibm.com>
In-Reply-To: <20250314161551.424804-1-imbrenda@linux.ibm.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Wed, 19 Mar 2025 14:02:09 +0100
X-Gm-Features: AQ5f1JrBHLjAttbOwvhIUgFHgjpUlzmrMNLWo1ZIkJbVPOCEfLZwT0qvNaInPjU
Message-ID: <CABgObfZ3nf-+466VWQ41GZ5T8cxo94eZmZJhK=jkCeDSDxfh6Q@mail.gmail.com>
Subject: Re: [GIT PULL v1 0/1] KVM: s390: pv: fix race when making a page secure
To: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org, frankja@linux.ibm.com, 
	borntraeger@de.ibm.com, david@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 14, 2025 at 5:16=E2=80=AFPM Claudio Imbrenda <imbrenda@linux.ib=
m.com> wrote:
>
> ciao Paolo,
>
> please pull this late fix for 6.14.

Done, thanks!

Paolo


