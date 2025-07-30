Return-Path: <kvm+bounces-53755-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B888CB167DB
	for <lists+kvm@lfdr.de>; Wed, 30 Jul 2025 22:56:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C6CBE3B572A
	for <lists+kvm@lfdr.de>; Wed, 30 Jul 2025 20:56:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B4B8521CC56;
	Wed, 30 Jul 2025 20:56:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dkdfHUFo"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E1F910F1
	for <kvm@vger.kernel.org>; Wed, 30 Jul 2025 20:56:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753908994; cv=none; b=Ux7E5cku26LUYd/KcHCRn0VE+ASsTxP1w+Br9tgvukeRXjmPnsG2T56dEz+VMkdpuyOQbf+XU+I52/buuHFrqEgvSLJd+e7TKXEHj302k1/f7wE8ksWmOiKPIZdcWPsCpSXbqsdtoWyxM7eSN+H1wC1u49/Mm1lSnYCSGdynk0I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753908994; c=relaxed/simple;
	bh=wvB4IKfv9zLzvYXzHLPNhTYZurYusIAEe15kaHn1//I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FPH1loncM724yQjGy4thQ+Rx5WfyTcmBQzuojOu8cePviBa5osdgrrDhkgINr+x2RAc3DL5tN922A32WcXJjCR1Dj029F1Ih857SnDu/SoV62Q9/MuuS2tmIBa2gJUH+M2KdqXZrWvjIIcL4+RZ92iG/yRk8LPo81decx7UFNJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dkdfHUFo; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753908992;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=OsAvW1xbbDY3IL4qeqk3YajzyugYI0d228HyXCGF9Vw=;
	b=dkdfHUFo2RplwpsdXLJFsj9xO59LLUHkJcH2q9GzsmjJuJhW/FQ474IiRCBqKyTXrJjsl+
	AjSkeGH6UBcUVg6TDF0aDMFK7UoWyCNpst+fX1tpgOsg1Lbuz4z3cZHdQVTbvqd+y+iB3L
	2OBWsrRtH28wdJ+jR/8gqRq4vTNmy+4=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-517-R_axnKO7PiK0g4mG6brHXg-1; Wed, 30 Jul 2025 16:56:30 -0400
X-MC-Unique: R_axnKO7PiK0g4mG6brHXg-1
X-Mimecast-MFC-AGG-ID: R_axnKO7PiK0g4mG6brHXg_1753908990
Received: by mail-qv1-f70.google.com with SMTP id 6a1803df08f44-70744318bdfso4654306d6.3
        for <kvm@vger.kernel.org>; Wed, 30 Jul 2025 13:56:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753908989; x=1754513789;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OsAvW1xbbDY3IL4qeqk3YajzyugYI0d228HyXCGF9Vw=;
        b=AnjiECY5nCMRLpS0DLWQDRaeOpxacDldgMAgFo+N/iVZ03WVGj06VSOfx7r6ek5uv2
         kpurye6CeM7FXhB3cqOrLrB0Jb7SkvS/useJQcFOsgDUgPf5ww6+7k07KVSoWensZvng
         og5/xkmCNI8XxviI3YvXtq+GKhlJwnt4TuGf3r9gRVq+4DeeYsVxxZRoGOH6i5zsXBrc
         L9i7rQN45kMDayudh+bh8AgGRbieXpQKa8VqqnJjKpuZ1xI7iyC3BL38xt1KLpoo6++y
         0z47kSOttUT2KjyN+mCSXg1P7/2K1QqxT6VZkDcjzL0BTXBTfXd/G+n0ZVBifr9VgnF2
         KFhQ==
X-Gm-Message-State: AOJu0YwZIXd3wRXqpoKqr4z2S0CGZDSiX8ZcIuze70r+iB6atjMbLp2B
	YjBP5ws/2ejSikRZ/zi65cTuiCQfJw1r9oYrc1pZ0fsSaq7o4WZMKb+sst1sJf/Bj9c4BbGpV1f
	n3tdX6CQJg6+8afvLc+tOEMVewAZgjXXFY0eLXRJBtO4DZf6vutoZlPTLctxTyw==
X-Gm-Gg: ASbGncupz3kprFNJ2c6S6dp7jx7NDC2mqGAqHUkZVDR+EQBCu8iAT79sR6mB6Fr4zSl
	9xLSubddFIbMPPv+gocGCCH0K+3KZVFHVLAfCXnwAt8ALhlVmDglL/coGrlNg82v+eyVMtOFDfa
	nFuTyYtbyn0yGjwLxj5LtbgX2OVA1Uzt3zGhl0Kr1+bYV0VSes7DIUrI/Vx+QbGc4l514mVBnA/
	O1eubmKVzfd/leCkj2S4sZ1jUWnsSdmCgtuSETKouzVYSk6u1hUg4I2mtCW3gBTgUk2TKjZVRV1
	cItEtJgeicgs4Q+DEsRVr03eX79JTWAoWCLB2cy+f/D+PoyXLylGpbVkrBi3vZoK5tDq74XuM7U
	GUOuIqIQ6ThPloFbA7IkbSQ==
X-Received: by 2002:ad4:5763:0:b0:707:5df5:c719 with SMTP id 6a1803df08f44-70767478e57mr81914066d6.17.1753908989485;
        Wed, 30 Jul 2025 13:56:29 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFfZh3Cs1t3FamufEveCv+4dQA1o0BCFhicNear2tX0jspAPHKZ0DqWSimzrXYSvNNce0e5Nw==
X-Received: by 2002:ad4:5763:0:b0:707:5df5:c719 with SMTP id 6a1803df08f44-70767478e57mr81913506d6.17.1753908988922;
        Wed, 30 Jul 2025 13:56:28 -0700 (PDT)
Received: from x1.local (bras-base-aurron9134w-grc-11-174-89-135-171.dsl.bell.ca. [174.89.135.171])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-70729a8302dsm65255146d6.30.2025.07.30.13.56.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Jul 2025 13:56:28 -0700 (PDT)
Date: Wed, 30 Jul 2025 16:56:27 -0400
From: Peter Xu <peterx@redhat.com>
To: Igor Mammedov <imammedo@redhat.com>
Cc: kvm@vger.kernel.org, pbonzini@redhat.com
Subject: Re: [kvm-unit-tests PATCH v4 4/5] x86: bump number of max cpus to
 1024
Message-ID: <aIqG-wU2X-Pm6ZVB@x1.local>
References: <20250725095429.1691734-1-imammedo@redhat.com>
 <20250725095429.1691734-5-imammedo@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250725095429.1691734-5-imammedo@redhat.com>

On Fri, Jul 25, 2025 at 11:54:28AM +0200, Igor Mammedov wrote:
> this should allow run tests with more thatn 256 cpus
> 
> Signed-off-by: Igor Mammedov <imammedo@redhat.com>

Reviewed-by: Peter Xu <peterx@redhat.com>

-- 
Peter Xu


