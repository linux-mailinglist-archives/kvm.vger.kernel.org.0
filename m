Return-Path: <kvm+bounces-37488-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0F80BA2AC29
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2025 16:11:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4F2573A7EDD
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2025 15:11:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 94CA41EA7D1;
	Thu,  6 Feb 2025 15:11:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mcrMijws"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29FEA1A5B9B
	for <kvm@vger.kernel.org>; Thu,  6 Feb 2025 15:11:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738854670; cv=none; b=dm4rLoVO7/ImpzqjF0DJ0l6Ne85UcXhgGD0N/WSuUP9hanuu6ReLcqb2han08sIayfspUmw1+IxIvEM3rt/KQbA0TlRz1a2AD9ITqVlXG3P5efpR/WYVqdKcs2q8ZvR8t2v9utY8nNaHeJ8qxZ+llMjUJ7QP8j7xvzhqurFOnlI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738854670; c=relaxed/simple;
	bh=HGcJvmPsA6VpGt/KK/cUj81/o/UDMPIaCrtDZurrAUo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ZIiQeYbx3FtcRGp0wwSgT7l6lQlwP6EthBSgdePgWkcD5n6my64EtHgZjGwfirxRUKg8DhPld2ScuZkA8hUbKZ1gFGvlaSgQbej0AZUylQmYHsodOK/wcaWRPqaKmtKYOGJmUyVpCuQQPUXrlwU20+t0SxVgkM/hJttfL3tUajY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mcrMijws; arc=none smtp.client-ip=209.85.218.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-ab76aa0e6fcso139830966b.3
        for <kvm@vger.kernel.org>; Thu, 06 Feb 2025 07:11:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1738854667; x=1739459467; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=HGcJvmPsA6VpGt/KK/cUj81/o/UDMPIaCrtDZurrAUo=;
        b=mcrMijwsXnwF51h15nZAyGn93Q2yjPXz8RZQvMHwpuzWscV0hk6cKpKydqo9chxrQo
         BPuQNq4m6xu/nZZL1DJ0lxMJh8Mhvn+UnAHaygCOMx2/PtSH4lII1abxSFoj+LBPCl0U
         jO9hMB2HaDn+b5toYn5FVCxcq4o+3E2560Q2vTVL50fPIw3K5XT0Gp6ua2Un//zMSCRt
         RKKtlRfvg1IaV7KOrKYt0RIO/h3y4G+PhHlvkO6SJ5ytMXnd0XRzVdc6XAdA+0UxNeNt
         sR+0TxGN9voDg5WmSnF/K9cC1MExtcHRrIvEWel37+pLp4tfXDYqc/H9Vz3h9QmVLlL0
         5Xag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738854667; x=1739459467;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HGcJvmPsA6VpGt/KK/cUj81/o/UDMPIaCrtDZurrAUo=;
        b=NGhqeGtNwwGlNJlX/uKVRFk74s+OxrwHqlZWu6YQSarvYPipW4IWBfmlVuXwlBtru7
         OraA1iEr7QPYYRTAtEOed2cam1FGeXbWfcR7odk7Z7Htjh/J1L+kMr5RHVR8jkkfHOww
         6LZnb7/cKj2Q70H3M2X0/OxDf7VBUAYTVUXOLXTQIpXQc4vUPypPl0Qfu7WzdlVrAIsv
         OS1GWo0s80DDp1XBzhO8a4uMLbVm6T0C/6wAujooGK/d5WC0YXfxb37TCu9T3TIAtIH6
         42QYd0j2sZg/Ziyt9qHzw6w6qTG5+TySXrcvZeR8D8mf+YN7NB/xykIbmZJFizuHYIFN
         CTQQ==
X-Forwarded-Encrypted: i=1; AJvYcCWb5ndWv/eiTnz1Wgtzmfqq4QM2l9T04bUAhkbWstt9CCmkn/RkNVi+30WjOc7Iw66cBvI=@vger.kernel.org
X-Gm-Message-State: AOJu0YylwB3yXNmSb6FOUnT+ckI/tuRhVcLx46YprilbpMT5k9gABvhx
	FOMrRlwS9TkKLEQSEkTJQAmvLjFcYH0uIyEXPK+8RyRdjeQxbvsvvyRK/ognVeGqdFLfM7BKSQJ
	BaTxRSN5w+1h+uInmypB6T7gNXos=
X-Gm-Gg: ASbGncvzTky7w3m6uDUletCrHsuPsJT5fbTeKH7wbZdQy4ZvMKy98Em97l8bR/wbLf7
	K8GaXWjCQFIgyMfZ6xw1IEV6BDZYpRVzffdbeyKe1ljnQKK8Ib5nG6JRdL/gM6P0o5XY8LAA=
X-Google-Smtp-Source: AGHT+IGP3KVjBq5joN2hvizSzR2CKIpkxWd+Wdla18g45vM5djnc7fvnLtfJ60Q3uZWqhnRyk/4SDaN62BZBaoaRfkU=
X-Received: by 2002:a05:6402:3506:b0:5d0:cfad:f71 with SMTP id
 4fb4d7f45d1cf-5dcdb775fbamr17536301a12.32.1738854667203; Thu, 06 Feb 2025
 07:11:07 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAJSP0QVYE1Zcws=9hoO6+B+xB-hVWv38Dtu_LM8SysAmS4qRMw@mail.gmail.com>
 <Z6SCGN+rW2tJYATh@fedora>
In-Reply-To: <Z6SCGN+rW2tJYATh@fedora>
From: Stefan Hajnoczi <stefanha@gmail.com>
Date: Thu, 6 Feb 2025 10:10:54 -0500
X-Gm-Features: AWEUYZkEgh3cyBoslP70EQWlaP_AQzysfImv92tTEUARYq7n1jgef6N53O8LJYM
Message-ID: <CAJSP0QUn5HHXKnxgt-Gfefz9d4PmRzPbgYv7Hoo=wcyO-rwQEQ@mail.gmail.com>
Subject: Re: Call for GSoC internship project ideas
To: Matias Ezequiel Vara Larsen <mvaralar@redhat.com>
Cc: qemu-devel <qemu-devel@nongnu.org>, kvm <kvm@vger.kernel.org>, 
	Richard Henderson <richard.henderson@linaro.org>, 
	=?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <philmd@linaro.org>, 
	Peter Maydell <peter.maydell@linaro.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Huth <thuth@redhat.com>, "Daniel P. Berrange" <berrange@redhat.com>, 
	Pierrick Bouvier <pierrick.bouvier@linaro.org>, Alex Bennee <alex.bennee@linaro.org>, 
	Akihiko Odaki <akihiko.odaki@gmail.com>, Zhao Liu <zhao1.liu@intel.com>, 
	Bibo Mao <maobibo@loongson.cn>, Jamin Lin <jamin_lin@aspeedtech.com>, 
	=?UTF-8?Q?C=C3=A9dric_Le_Goater?= <clg@redhat.com>, 
	Fabiano Rosas <farosas@suse.de>, Palmer Dabbelt <palmer@dabbelt.com>, 
	=?UTF-8?Q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>, 
	Hanna Reitz <hreitz@redhat.com>, felisous@amazon.com, 
	Stefano Garzarella <sgarzare@redhat.com>
Content-Type: text/plain; charset="UTF-8"

I have added your project idea to the wiki. Please make further
changes directly on the wiki.

https://wiki.qemu.org/Google_Summer_of_Code_2025#Adding_Kani_proofs_for_Virtqueues_in_Rust-vmm

Thanks,
Stefan

