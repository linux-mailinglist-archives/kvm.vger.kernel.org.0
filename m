Return-Path: <kvm+bounces-16262-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B6BAD8B8085
	for <lists+kvm@lfdr.de>; Tue, 30 Apr 2024 21:30:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6CDE3284AA6
	for <lists+kvm@lfdr.de>; Tue, 30 Apr 2024 19:30:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 05B4F199E88;
	Tue, 30 Apr 2024 19:30:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="RUOH/U3T"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21A9A194C9E
	for <kvm@vger.kernel.org>; Tue, 30 Apr 2024 19:30:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.139.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714505405; cv=none; b=HvXIGGugds7dkVbNx5Yk6UxnQs1T21MLdAtR3JwOacZ1tlDBXdWw6vbGmAlfEc+uR3zXlYJJOEXL0kQmKZFaCh6vRiGbdkNFbQ0t101ZTzYg/tc1qEImCZnaWBCNlXcqUL4T+ACKg5zHzkNztSMrkV9yO88uKavf8myY8jxcpsA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714505405; c=relaxed/simple;
	bh=lJ8gp0NYd9wG/QoyYsmtFfPkGu0N506QK1W8f8hKE3I=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=lCl+TGniOc9OKIGJLZfW5lIKopwORmWR2s5az4h5jj+ab1VehvOmAGuiSjUlgk8J/PtOclHFtERy39bkseFdq/ONNxtfB+qZYpcGbkmbE+NPPuf5k+49Mss/Ug1gphcyl0tLHZ6HBz1Lq111lDSC/4/jiD7P7G3/cE805pcF0Pw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cs.columbia.edu; spf=pass smtp.mailfrom=columbia.edu; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=RUOH/U3T; arc=none smtp.client-ip=148.163.139.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cs.columbia.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=columbia.edu
Received: from pps.filterd (m0167075.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 43UJFTtH003696
	for <kvm@vger.kernel.org>; Tue, 30 Apr 2024 15:29:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=mime-version :
 references : in-reply-to : from : date : message-id : subject : to : cc :
 content-type : content-transfer-encoding; s=pps01;
 bh=oc6kRPcRubpTdbbh9aZFXcZ0hJcAAlplqE5O2JpJvY8=;
 b=RUOH/U3T6h0GQ5BjA0yfokmOt+K5fZtvY9pktAMHPBggF8mFHhO4Xv6tjA2shihvqEQU
 26EiruThwle+cRXPxA75I9rzIskBiywZZd5jz1OX1qUqOEc9IDUm/5kcdB7VViXZ8jb4
 8DvyzBKnd8nKr6DLbyoqmCHDBA/VfiKjRiVRBCi4jPJHfjqCdWRWa/qsNq19PikNy+Oo
 wstQa/NdPH6cm/G3x2+uAP2Ha2kynzRSebpqkMhXr9MlN3zOwBbSPokWKAO5OA6VG4eq
 VwzA/rHxxet0olEZpXBUlcxoGAQE9ryWb998jhZu5371OfV8y0OYkWsMG0A1ou+sb339 Mw== 
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com [209.85.166.72])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 3xrwbt9gn9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <kvm@vger.kernel.org>; Tue, 30 Apr 2024 15:29:55 -0400
Received: by mail-io1-f72.google.com with SMTP id ca18e2360f4ac-7ded263daeeso36022839f.2
        for <kvm@vger.kernel.org>; Tue, 30 Apr 2024 12:29:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714505378; x=1715110178;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oc6kRPcRubpTdbbh9aZFXcZ0hJcAAlplqE5O2JpJvY8=;
        b=f6y9l/5dLUW/xdpgm/tOfezVeelSE4YjLsaSd+U/Fu0CQfAZn1TijWFsGNhXUDq7zR
         rfBn0hU/E5AXSQ1fYHiaa0PBeXpjYLVtXQoViq5Tas2mu1lPTu2CoZYt2v/B7noZ+ok+
         osL5mlnRSRQEqjhkLpXmMsHbEf79UKHR1/CbB2Qjd5yFZTqwrD8nozPsCFatCnTQoCQ1
         ZoanGZCFvKIz3FiS3B3T4j5r7iV5Tk6tkmLghYyXeJfezmru4gf++03tJ7h/2oAmQdje
         AyPH4EUqyrGJdpscY+iZDLq0h99feYXCkcQVU7t6CzHXpZtLhcZRCENxr63ovObqca+6
         75Aw==
X-Forwarded-Encrypted: i=1; AJvYcCWVkzlxJsj58nvw+Wi8dkyj1gv66fEUbAtiSeAfRqil5NTvmwDWXtQS9gm9l9J6UvcDqGKaRlmlEsF+cB2we2jMkeQq
X-Gm-Message-State: AOJu0YzR3wjwO0KV9c3aJGL/04OZ0LY+QLayYcb/orJPlVdPnotDNANF
	oDP3xlpz/UYvQP01G23aP/CutbnmwVfXdLKl4/1M/4dSAbXAxwXDrKVF6hway0JWYuIVFEGtJx/
	CagKgQAMwk0dkwAWlj4JCbwerSOpM5j2oDyBjJqGStBgbM2v4ZFVhhez2CMhOevQJfp+WsXuJp5
	oHMzDVfO+UjSk6dDbY5GwyqSLCrLv8
X-Received: by 2002:a05:6e02:13a5:b0:368:974b:f7c7 with SMTP id h5-20020a056e0213a500b00368974bf7c7mr870865ilo.0.1714505377726;
        Tue, 30 Apr 2024 12:29:37 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHVZ5eVX/DFyc6ZnORp/zfn+c+/E5krTaQ8B3t4hgiFErNsnVt3+K6VkFnwU2mAH1p7a+RcMCNLAB+CJJnexNk=
X-Received: by 2002:a05:6e02:13a5:b0:368:974b:f7c7 with SMTP id
 h5-20020a056e0213a500b00368974bf7c7mr870855ilo.0.1714505377430; Tue, 30 Apr
 2024 12:29:37 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240423024933.80143-1-kele@cs.columbia.edu> <de0096bf-08a8-4ee4-94d7-6e5854b056b4@intel.com>
 <CAOfLF_L2UgSUyUsbiBDhLPskt2xLWujy1GBAhpcWzi2i3brAww@mail.gmail.com>
 <CAOfLF_+ZP-X8yT7qDb0t57ZZu7RNhdOGyCNfR2fheZG+h_jZ7w@mail.gmail.com>
 <ZivTmpMmeuIShbcC@google.com> <CAOfLF_L+bxOo4kK5H6WAUcOeTu5wFiU57UtR5qmr1rQBT5mAfA@mail.gmail.com>
 <Zi__ZF5SY2k7BtTE@google.com>
In-Reply-To: <Zi__ZF5SY2k7BtTE@google.com>
From: Kele Huang <kele@cs.columbia.edu>
Date: Tue, 30 Apr 2024 15:29:26 -0400
Message-ID: <CAOfLF_+GHrvqWK48YSwbJciM9n=QA9bHn-PjZSd9uo37Gx0ZMQ@mail.gmail.com>
Subject: Re: [1/1] KVM: restrict kvm_gfn_to_hva_cache_init() to only accept
 address ranges within one page
To: Sean Christopherson <seanjc@google.com>
Cc: Zide Chen <zide.chen@intel.com>, pbonzini@redhat.com, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-ORIG-GUID: HTWDADBMq0wUUeShptbSyw4h-WqNiOra
X-Proofpoint-GUID: HTWDADBMq0wUUeShptbSyw4h-WqNiOra
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1011,Hydra:6.0.650,FMLib:17.11.176.26
 definitions=2024-04-30_12,2024-04-30_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 mlxlogscore=872 bulkscore=10 priorityscore=1501 mlxscore=0 adultscore=0
 malwarescore=0 clxscore=1015 lowpriorityscore=10 spamscore=0 phishscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2404010000 definitions=main-2404300140

On Mon, Apr 29, 2024 at 4:13=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:

> Oh, don't get me wrong, I completely agree that the code isn't straightfo=
rward.
> But I don't think this is a problem that can be reasonably solved in the =
caching
> code, at least not easily, as a lot of the oddities stem from KVM's memsl=
ots, and
> KVM's contracts with userspace and the guest.

Thanks!  I agree with you.  It seems using flags to indicate that
cross-page cache
initialization failed and checking flags on following guest memory
read and write also
would mess up the code.  On the other hand, simply refusing to set up the
cross-page cache initialization also would confuse users.  I think it
is good to check
the validity of asserts before using it.  Not sure if a brief comment
is helpful to it.

