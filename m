Return-Path: <kvm+bounces-37590-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 6FC44A2C43C
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2025 14:58:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 51DA6188B419
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2025 13:58:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D1B411F78E0;
	Fri,  7 Feb 2025 13:58:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="N4AVxFpZ"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECBC91F4198
	for <kvm@vger.kernel.org>; Fri,  7 Feb 2025 13:58:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738936719; cv=none; b=MK2NNhQHz9S0f1GkcHlbIGd4JJ+fOMiMP7zl5ysaryQk2CTQb92EIPbe1Qd6pMV1EMg0jAGB/9aTodjM0l1YwKZohtGJt/K/N7Lh4LkrMoBZArdp7SClbGbG8C8L2ki23epAqP+fTX6Tsfu/u6kw6yIqR1yMlVA0EeLDtZddsgQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738936719; c=relaxed/simple;
	bh=EwaPIYvFlO4H67N+ZcE44sIK8xJqCXUADcDUL7a/gWQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Uo2ILg2LPItHabLaejF85zwucOMzP2l87plubntDlG00lyOH0zCORcC7SXBiLic0cJ0egkljy6vo/BO9WXuCw83WVPP6pPAtDb4Ky4sdfSW0QRx9eJoZ8BILbDRYLr9IWV90XtRq/1cRdnXz8zRECcpoPmn2/X2x9GYx3CYqID4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=N4AVxFpZ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1738936715;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4ybkpDxhu8xKTs+Y+7/yzdIG4KMftXrJD68DsnKZ67E=;
	b=N4AVxFpZ5hB83QyjyWDKP3fByS/3ZaSneuhT4Pjgf1geR92zQKZkq6qfHDKWlnmC8UpbFk
	Xr0Yny9A60dLBwFRxBb3ElALaFqdugC8isACbvdTKNm2UpQ74Ci8kJm+DbmO50KCVf5VLk
	W66Quo3l0hUz0XAvSMeaVvQgZ9Z3YqY=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-166-FoV7l7nvO3mEoNoZXvxbSQ-1; Fri, 07 Feb 2025 08:58:34 -0500
X-MC-Unique: FoV7l7nvO3mEoNoZXvxbSQ-1
X-Mimecast-MFC-AGG-ID: FoV7l7nvO3mEoNoZXvxbSQ
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-4361efc9dc6so11983955e9.3
        for <kvm@vger.kernel.org>; Fri, 07 Feb 2025 05:58:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738936713; x=1739541513;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4ybkpDxhu8xKTs+Y+7/yzdIG4KMftXrJD68DsnKZ67E=;
        b=euNG79X+2wbM8rCBP6KgME1Ctv069QIxUVxtbQb6d4mk7rbDGZD+HdYg2R24g1fVLy
         Y1wvSLg4hNOSnEpi1lMIQt7SCBCE7W9/hOAOUmC0dg2jnf0EQdOdOOzV2FhBSYIck+4I
         o/s9JciOXNXvtvVcsBkG+usis5/30no3NH8eyEMpWRV6SmKs1ROhkZ2qAOWa8UPGnCL+
         MXMzl3WQnMG3gr5X3slCUEDBOW21nw9kjcYw1eefedmRT4wueINgVQ+m0DAGP+qJvegb
         zdzbvLuPESp7q7rUpGk2Nqu0+401Z9q7jrD+YfYfBXdWjYKi5kAsDSGMXOMoSWFFcfQr
         kalQ==
X-Forwarded-Encrypted: i=1; AJvYcCWZYBX5jxwP+Mpi/Bb/SnaVCB/AlF+Kbu2G9LCXTci50XA4ixwDDuzH8fa7dT2QUV9BUZQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YzDVXN2nfK+q/izId5bw3DSa5ubD26XCV7tk8Fr/W99iBUAWTwn
	ZaB+s6InVmApL92HE63gqTt6Quy8M1x486iaJa4W1G2p435l8b5LxM8FEOuRPB2+chQl78GIBow
	+QitNPmlBfXqh1WzeZjX4Rvw1I4an7gBEHkTcFCYO2uZOBc6DRA==
X-Gm-Gg: ASbGncvHmUMpzXF8b6lZwmfb1xNRksPGlmEI5OoRvul/im0CTlV2c4frSyXcCrDyHGX
	Ay3BDfDCJeso0+V65poPYrNt5IsZHCfNy+Mc34GTnHmLRLn7WmveP6hercmDD6e/E5obehSvGhB
	+TRa38BjA39AvKERf57OpAndHgClXDZ03PLamKLjkV7UpxJBwQ2OZp+lEAd6TsN/0nnRIWoFl3W
	4RtzCk6eTXu0HoRuAhCePgRUPVxgHRiY6VQYQymllALKT1JlKEuGdPo37t4HF/ZAiLF+7MakTY=
X-Received: by 2002:a05:600c:3ac7:b0:434:eb86:aeca with SMTP id 5b1f17b1804b1-43924988cc1mr30625495e9.10.1738936713321;
        Fri, 07 Feb 2025 05:58:33 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHWKxqNkRKndTKkmKggWjw0seZyEZD5by0v8O14yZp7nP1WHLcap0rNEWLJlhYsKrY1IvFHAg==
X-Received: by 2002:a05:600c:3ac7:b0:434:eb86:aeca with SMTP id 5b1f17b1804b1-43924988cc1mr30625285e9.10.1738936712990;
        Fri, 07 Feb 2025 05:58:32 -0800 (PST)
Received: from fedora ([2a01:e0a:257:8c60:80f1:cdf8:48d0:b0a1])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4390d93379fsm93570975e9.5.2025.02.07.05.58.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Feb 2025 05:58:32 -0800 (PST)
Date: Fri, 7 Feb 2025 14:58:30 +0100
From: Matias Ezequiel Vara Larsen <mvaralar@redhat.com>
To: Stefan Hajnoczi <stefanha@gmail.com>
Cc: qemu-devel <qemu-devel@nongnu.org>, kvm <kvm@vger.kernel.org>,
	Richard Henderson <richard.henderson@linaro.org>,
	Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?= <philmd@linaro.org>,
	Peter Maydell <peter.maydell@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>, Thomas Huth <thuth@redhat.com>,
	"Daniel P. Berrange" <berrange@redhat.com>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>,
	Alex Bennee <alex.bennee@linaro.org>,
	Akihiko Odaki <akihiko.odaki@gmail.com>,
	Zhao Liu <zhao1.liu@intel.com>, Bibo Mao <maobibo@loongson.cn>,
	Jamin Lin <jamin_lin@aspeedtech.com>,
	=?iso-8859-1?Q?C=E9dric?= Le Goater <clg@redhat.com>,
	Fabiano Rosas <farosas@suse.de>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
	Hanna Reitz <hreitz@redhat.com>, felisous@amazon.com,
	Stefano Garzarella <sgarzare@redhat.com>
Subject: Re: Call for GSoC internship project ideas
Message-ID: <Z6YRhs/MaVs30Z/R@fedora>
References: <CAJSP0QVYE1Zcws=9hoO6+B+xB-hVWv38Dtu_LM8SysAmS4qRMw@mail.gmail.com>
 <Z6SCGN+rW2tJYATh@fedora>
 <CAJSP0QUn5HHXKnxgt-Gfefz9d4PmRzPbgYv7Hoo=wcyO-rwQEQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJSP0QUn5HHXKnxgt-Gfefz9d4PmRzPbgYv7Hoo=wcyO-rwQEQ@mail.gmail.com>

On Thu, Feb 06, 2025 at 10:10:54AM -0500, Stefan Hajnoczi wrote:
> I have added your project idea to the wiki. Please make further
> changes directly on the wiki.
> 
> https://wiki.qemu.org/Google_Summer_of_Code_2025#Adding_Kani_proofs_for_Virtqueues_in_Rust-vmm
> 
> Thanks,
> Stefan
> 

Thanks,

Matias.


