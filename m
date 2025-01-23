Return-Path: <kvm+bounces-36317-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E6712A19CF6
	for <lists+kvm@lfdr.de>; Thu, 23 Jan 2025 03:24:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9BB993A69B8
	for <lists+kvm@lfdr.de>; Thu, 23 Jan 2025 02:24:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3765A1D555;
	Thu, 23 Jan 2025 02:24:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ucsd.edu header.i=@ucsd.edu header.b="tgJihbWc";
	dkim=pass (1024-bit key) header.d=ucsd.edu header.i=@ucsd.edu header.b="QBDnSJg7"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-0016e101.pphosted.com (mx0a-0016e101.pphosted.com [148.163.145.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 816CA3232
	for <kvm@vger.kernel.org>; Thu, 23 Jan 2025 02:24:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.145.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737599092; cv=none; b=d0zBHo9fl0mfxWCfH+NXMqtbDRDY8Dlgy+Z9Mp+iyyQuGl7pAtdqNCmZ9bZShAnZw+tqH9dO4bYv0qnLYwqOcL/QyuXxnAeW0mvxwdsX/O8tzn0cjI6TTzKG/pWt80JmoO2sLlpuFs6978FFBTYobyUP9NFqd8DOaDQ83tBQyDU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737599092; c=relaxed/simple;
	bh=SOWq8opGOf5ZUc/uDQpVS1lctYeGQOyoryrQnEdpcFQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=NEmOPJF6usq6EWOFybfYFdl4/gcMZ7ZOcH83U4Y2CWjETsRw0gcTaTBOhGSH5O1GT6YwQDsmBJCbRaeA8kvbsbYEOdMeI7iWK0ku6mQl3Dq0U+BXCBm9zQ31LL6LmV8QiXzppUD8HkBuh6hb1eO8SB/ixrJ7Z7ZbKAMrsOYwmOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ucsd.edu; spf=pass smtp.mailfrom=ucsd.edu; dkim=pass (2048-bit key) header.d=ucsd.edu header.i=@ucsd.edu header.b=tgJihbWc; dkim=pass (1024-bit key) header.d=ucsd.edu header.i=@ucsd.edu header.b=QBDnSJg7; arc=none smtp.client-ip=148.163.145.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ucsd.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ucsd.edu
Received: from pps.filterd (m0151353.ppops.net [127.0.0.1])
	by mx0a-0016e101.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50N298u9006126
	for <kvm@vger.kernel.org>; Wed, 22 Jan 2025 18:24:49 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ucsd.edu; h=cc :
 content-transfer-encoding : content-type : date : from : in-reply-to :
 message-id : mime-version : references : subject : to; s=campus;
 bh=SOWq8opGOf5ZUc/uDQpVS1lctYeGQOyoryrQnEdpcFQ=;
 b=tgJihbWc7gWYQdtfjMUU42ANy/KSSOKPkceGEhPhUneHLqjeOMD/zF1D3Z6nd4egj8Ep
 DiFMmOnvjn5Iz6dK+RTrKBQTL7d7/DLoaQPNWCQ9/HqlKcmwUvDdo1evPJRL+ShCo0JG
 f3e35+4tG/g9H+A0Z5aVB8FYteaKFK961AZMEb8YwXHKIbQq/r0WB5uYArIjRfXjnYZi
 Y5kUekf6OK10wCYDXNUBrki1MERFDMrFPmqLYVtlg3qdG4ebX7nBJYNkGTiFFeDW0nA2
 CMt9eJDbvEgO8z2ISrBZDXSjHy+tSrdkqlKWCgMwufWSeTR+B4FRuqNn0erQ963KCKld LA== 
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com [209.85.216.72])
	by mx0a-0016e101.pphosted.com (PPS) with ESMTPS id 448ce18se3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <kvm@vger.kernel.org>; Wed, 22 Jan 2025 18:24:49 -0800
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-2ef9864e006so1397859a91.2
        for <kvm@vger.kernel.org>; Wed, 22 Jan 2025 18:24:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ucsd.edu; s=google; t=1737599088; x=1738203888; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SOWq8opGOf5ZUc/uDQpVS1lctYeGQOyoryrQnEdpcFQ=;
        b=QBDnSJg7FJ+fEtAjEFNxiOEQqg3SxX3EAFrURcq2e3zutPpI0HPq9EBJkd5gp7iQ5n
         6S1RiyufZx3fiQ9q1OqwbhKkE2SG+Gt1/yhgAPW2eJAMBVIS3NX2cREbNky/Zq/bJ3FG
         E2bqwRrEdUG1We0DHkx4soFvw6bTp/e09NVWc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737599088; x=1738203888;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SOWq8opGOf5ZUc/uDQpVS1lctYeGQOyoryrQnEdpcFQ=;
        b=UZX8V72RDmDT25kdQEIIVAtKOzyXL2VZNoC13WU1cuZRi3B/6+us3kM0C2c8MoMQTG
         4DHrBc3QW+NhlVqVUMK00xkuSkIAe0yLShdEyZG4oVqW7Fu2kqWcVv5izml3bSuJa9Qg
         0ecH3D3QHksFCkyi+uw5JGV3eyVhpX5v5xQ8/XnfY5ccLLnuob2L5uysRNAFzmBzfcOA
         q1GsyAMoRrIiz84FEb56xHJDtg3iGQrbv0Uk5i9/VgmTJKYdCAysAlOIi1IcRt4VAEsL
         KQLG3/3rJqXc0g9LF/Y07ngoIztAqFapSr87XTez1aoBbJJ6GA1SW0N1kpdrFxCA66NP
         AAIQ==
X-Gm-Message-State: AOJu0Yy5D7b4RzWvnevGNIdY1ERVWq+z6g5BSYA1nBQ4MAzWd/Zz/y4l
	oLdQHrs3Kdcn44qAd7rEbtZc3VEf10cHr0/zZ8L3OsQbC31k3Pclo9u46E5tRaZxGEhuLHY2dmD
	B8NTzXq5GAGLEBHCnfVYSZx62iwIOFv9YQQ9IF9NcpVynD/cIFUr8aDSdvgCAK/v6KpqzEhWS01
	/4IKhw+q/+2cMXfw/CjFl/S3C/FLoxEy6+V1ML
X-Gm-Gg: ASbGncvDOx1ss3QqTcVnQ+2lEj++j2yi4Wo4ZM4PzK7I+QTw0QLRxHaTodXslZov1wc
	GbzGMP8mzkiL3gNcndMHbPk86M1C911UNed4Z9OpHFQ6hIxQHeA==
X-Received: by 2002:a17:90b:4d05:b0:2ee:5958:828 with SMTP id 98e67ed59e1d1-2f782c70176mr35750517a91.9.1737599087702;
        Wed, 22 Jan 2025 18:24:47 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGawzYy2hH3GfBlrxfKiL2W3CbuObHk83JGj/EeplLbm9A2CX4+19SS8dSrcls7cu+W9kIy9/zdfO6g1ea1IJc=
X-Received: by 2002:a17:90b:4d05:b0:2ee:5958:828 with SMTP id
 98e67ed59e1d1-2f782c70176mr35750500a91.9.1737599087386; Wed, 22 Jan 2025
 18:24:47 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CH3P220MB190880164B32300C91BBA037AAE12@CH3P220MB1908.NAMP220.PROD.OUTLOOK.COM>
In-Reply-To: <CH3P220MB190880164B32300C91BBA037AAE12@CH3P220MB1908.NAMP220.PROD.OUTLOOK.COM>
From: Aaron Ang <a1ang@ucsd.edu>
Date: Wed, 22 Jan 2025 18:24:36 -0800
X-Gm-Features: AWEUYZkLBpbyo3-bU-RaaosBCP_3hRgIyUMCmHSlvvVV6IJo8yif3MZ6IqR-dzs
Message-ID: <CAK51q6WPAWbmqL=qaiPU1cg1rNAehzUpaZS3K-oWmRU+KD5Gug@mail.gmail.com>
Subject: Re: Interest in contributing to KVM TODO
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Cc: "jukaufman@ucsd.edu" <jukaufman@ucsd.edu>,
        "eth003@ucsd.edu" <eth003@ucsd.edu>, Alex Asch <aasch@ucsd.edu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-campus_gsuite: gsuite_33445511
X-Proofpoint-GUID: FC4D7NkNzdd4yayQ7EWR4P6K6ydn2WnY
X-Proofpoint-ORIG-GUID: FC4D7NkNzdd4yayQ7EWR4P6K6ydn2WnY
pp_allow_relay: proofpoint_allowed
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-22_11,2025-01-22_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 impostorscore=0 spamscore=0 phishscore=0 malwarescore=0 lowpriorityscore=0
 adultscore=0 bulkscore=0 clxscore=1015 mlxlogscore=745 suspectscore=0
 mlxscore=0 classifier=spam adjust=-50 reason=mlx scancount=1
 engine=8.12.0-2411120000 definitions=main-2501230017

Hi KVM team,

We are a group of graduate students from the University of California,
San Diego, interested in contributing to KVM as part of our class
project. We have identified a task from the TODO that we would like to
tackle: Improve mmu page eviction algorithm (currently FIFO, change to
approximate LRU). May I know if there are any updates on this task,
and is there room for us to develop in this space? We also plan to
introduce other algorithms and compare their performance across
various workloads. We would be happy to talk to the engineers owning
the MMU code to see how we can coordinate our efforts. Thank you.

Regards,
Aaron


On Wed, Jan 22, 2025 at 3:19=E2=80=AFPM Aaron Ang <a1ang@ucsd.edu> wrote:
>
> Hi KVM team,
>
> We are a group of graduate students from the University of California, Sa=
n Diego, interested in contributing to KVM as part of our class project. We=
 have identified a task from the TODO that we would like to tackle: Improve=
 mmu page eviction algorithm (currently FIFO, change to approximate LRU). M=
ay I know if there are any updates on this task, and is there room for us t=
o develop in this space? We also plan to introduce other algorithms and com=
pare their performance across various workloads. We would be happy to talk =
to the engineers owning the MMU code to see how we can coordinate our effor=
ts. Thank you.
>
> Regards,
> Aaron

