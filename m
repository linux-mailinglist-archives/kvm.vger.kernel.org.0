Return-Path: <kvm+bounces-72155-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id uHbdL/+noWm1vQQAu9opvQ
	(envelope-from <kvm+bounces-72155-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 15:19:43 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id D79AE1B8BC1
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 15:19:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 664CF30508DE
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 14:02:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3FD65421EE9;
	Fri, 27 Feb 2026 14:00:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="n/sz1jEk";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="GuFhh7Ge"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 014E841B35B
	for <kvm@vger.kernel.org>; Fri, 27 Feb 2026 14:00:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772200849; cv=none; b=R9zrd6j6UnxEHpn9ixKT0aMXpu10JAvODS/9fnf/Fy7ZKHS23sOPtsR/Qu0A2DILvtl2Qc5OAlq5+6uII+WcGNCGFx4qUXtbwDSxWHAtKq1emigD55MKt7xOzPj984emVcse6F6xar9TPPW+/miz/MpxZkHMAsl24lV2VKa11eE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772200849; c=relaxed/simple;
	bh=8lwXSRo7NPacbIIvhFTzxJbwX+KIp/2i2qGE2QKcudM=;
	h=Mime-Version:Content-Type:Date:Message-Id:Subject:Cc:To:From:
	 References:In-Reply-To; b=Dx3GgE/6LLHuSdLD3/6EYQgzZ5yh8F67LjdhsbC1UfNOE45PobWSSbE0e5PkieD6t8uyheO+KA6bf4XMzikF2t46gbriQNeERpo7EKarTjk+ujs0cBLMUBB4+p9FjWqIf96ziTYkuWrdZaMyG0EINstRES/TAR98EB7XOiZJE6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=n/sz1jEk; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=GuFhh7Ge; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61RALtLb031274
	for <kvm@vger.kernel.org>; Fri, 27 Feb 2026 14:00:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	jlqb7BDCgmRJ1hZWQTjrCQIUXtq6dQQDj7TPdTyfFFg=; b=n/sz1jEkHInV5jOy
	e0RKqa6YVl9I9NKH7WAjGgq03/1uT4zvXCxSH0qdl/Eje6caKVQKnSjJmdfaTuwM
	hwmUs15YKtaF9kuyXp2eNKTNES+zCsx0vAjmrEqQh/4uKY+aJs4IBRxLtWjofxqz
	Rp0BZFdRAQbXvtg9qwNdlLTLqaxRALAAxaLe358mssyJ5hjJIRmQGh6y7OYbBtwj
	J8H4wRfEcT56CiwfOhVDxL3JPaw+XdlQEXfnvhHneRTvw7kh7G5BBkImDMo9oy92
	BBCiiykbg+2MHbGPTHF/gNvbWSHWcatu1rKqoYkGZwd58i8UJBhzZDI0IiZ7wPtC
	g5bWtw==
Received: from mail-vs1-f69.google.com (mail-vs1-f69.google.com [209.85.217.69])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ck9f00kjn-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <kvm@vger.kernel.org>; Fri, 27 Feb 2026 14:00:46 +0000 (GMT)
Received: by mail-vs1-f69.google.com with SMTP id ada2fe7eead31-5ff0ce6f945so20044132137.1
        for <kvm@vger.kernel.org>; Fri, 27 Feb 2026 06:00:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1772200846; x=1772805646; darn=vger.kernel.org;
        h=in-reply-to:references:from:to:cc:subject:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jlqb7BDCgmRJ1hZWQTjrCQIUXtq6dQQDj7TPdTyfFFg=;
        b=GuFhh7GeXzrHU/0mzzmVmHYXQX3JZprfOiru62awrzYvqzRRBf70QPxp90SECy+8fK
         DnbAtPmb2RYKZQ0cYD4YcZvR17gPx7i3q4hhRtIjpQ6qvq32cSPdbzhIRoNj0pA/i/WB
         qR5Buj2B9Rd2i02gvuSF3+VEGPkKtP/4Vzy7YGTI51q0NEGLEwM+oInU7MCYnlHv0Tic
         hQPfQVfZeeAE+/h16srEq19WFztAodk5Iod9sE2mn2k+x66RE2T0l+TROQK9FUMHL5KS
         04MV/sXAMpxBt01AzeSpXXbO/ekhFSkp8AVx6plUxMtEREt72qY41+0SjhvDXCfeMRrd
         YRgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772200846; x=1772805646;
        h=in-reply-to:references:from:to:cc:subject:message-id:date
         :content-transfer-encoding:mime-version:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=jlqb7BDCgmRJ1hZWQTjrCQIUXtq6dQQDj7TPdTyfFFg=;
        b=XQWqRIuNoTQNVfYJQior7Zmt5ClOv/E1zBwP9tN3bkil8tThXrhdkXKllNB9de1n8N
         vpA19wTFkSqGoB3TZ4SNh+p1zd4dICYR/KP4Mc1WxNAn0Zv5SzdSILpm6GbRYaqPEXHV
         S7X4P8OeyMyh4SsZeVWQbRwrQzGQJmLhqal0I3qhTAtCiJOh4rL+i8XxfZJrbBak+abZ
         Y/JXDqGyc6ubt2xTBU1SD/00PJFblgd1ofLi3DOz2cqKJUbT53cYBMRlVpTZ30Ix3efH
         hBfCCQKtV/6A3KUrB4R1HaMJsK4F/x0Dmw/hcT+9YvZxw4wVhs1oTm1j4XEU3Rlrt3m4
         PtsQ==
X-Gm-Message-State: AOJu0YwEQnqQqSOzOQYEglyV1Ar8qyKCTiOBkO53iEKhPTdNqApoeCYx
	W69WsQV4+Xdr+A0GV8EtUkjjeZJKjkdFvdicZj6giVcGgiCw/fWtsnVQF5UTbRzT5dQ5OdpL69N
	F/yd9/TAH5LFO5iGMWyUAJdT2qPnhlVV/KmbnaStAFwreMG95DdB5XG4=
X-Gm-Gg: ATEYQzzdCCVmEPbjCCM5jXVZAR3svWml35fmIVgQgBa/t1VyyipbnXO5QIh87NUuNei
	4pO5NBrrD9VRyL3TKv1QKOSEWLAGG/mF1/Bq9w8xFDOsJQgrkUd+AvyBYNC5CHn+Cz/v7lXvPBA
	1PG+hZqXSdCR1kD+zAJQf0RzOVzrtjT+rXYK7fqgY9Ky/0/Gi6wmQBGdO/J72Cs4dnzplsfOio6
	4sDRKpXsU/NYZ1IyWJ9buoIqvj16qaFoSDRSOMoNY+41KV3tF5+t5HLaGt6sfHxh36p8irmA2Cj
	9rYb+gNOKRpn9u/Gj5K30WUf7IyN1FCyr9mFIslcS8x1qoLgEP1FBRrSTNE4JdIOl+pxImlOq8h
	PsW74oxK3GnxH2ALKf+UdZi2U1IC2t1X39W9Ot1IEDuq4aUgmk/PLYMtB47G1
X-Received: by 2002:a05:6102:945:b0:5fd:b46b:d5a6 with SMTP id ada2fe7eead31-5ff1cf4a2edmr3779343137.12.1772200846086;
        Fri, 27 Feb 2026 06:00:46 -0800 (PST)
X-Received: by 2002:a05:6102:945:b0:5fd:b46b:d5a6 with SMTP id ada2fe7eead31-5ff1cf4a2edmr3779295137.12.1772200845537;
        Fri, 27 Feb 2026 06:00:45 -0800 (PST)
Received: from localhost (ip-86-49-242-13.bb.vodafone.cz. [86.49.242.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b935aeee867sm149340066b.66.2026.02.27.06.00.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Feb 2026 06:00:44 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Fri, 27 Feb 2026 14:00:43 +0000
Message-Id: <DGPSROCWMJWD.33FHG4JOPD2V8@oss.qualcomm.com>
Subject: Re: [PATCH v7] KVM: riscv: Skip CSR restore if VCPU is reloaded on
 the same core
Cc: <kvm@vger.kernel.org>, <kvm-riscv@lists.infradead.org>,
        <linux-riscv@lists.infradead.org>, <linux-kernel@vger.kernel.org>
To: "Jinyu Tang" <tjytimi@163.com>, "Anup Patel" <anup@brainfault.org>,
        "Atish Patra" <atish.patra@linux.dev>,
        "Andrew Jones"
 <andrew.jones@oss.qualcomm.com>,
        "Conor Dooley"
 <conor.dooley@microchip.com>,
        "Yong-Xuan Wang" <yongxuan.wang@sifive.com>,
        "Nutty Liu" <nutty.liu@hotmail.com>, "Paul Walmsley" <pjw@kernel.org>,
        "Paul Walmsley" <paul.walmsley@sifive.com>,
        "Palmer Dabbelt"
 <palmer@dabbelt.com>,
        "Albert Ou" <aou@eecs.berkeley.edu>,
        "Alexandre
 Ghiti" <alex@ghiti.fr>
From: =?utf-8?q?Radim_Kr=C4=8Dm=C3=A1=C5=99?=
 <radim.krcmar@oss.qualcomm.com>
References: <20260227121008.442241-1-tjytimi@163.com>
In-Reply-To: <20260227121008.442241-1-tjytimi@163.com>
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjI3MDEyNCBTYWx0ZWRfX4uQ5TP5DJL5f
 35i+JcObRPKKWql5jJrJmCNT1BgkFejfe5R7BIJGHdnOI/JRRnecKkf/lYaxqs6gsL1DBuS7rqQ
 pigjc5ORQ9rfzjE9f5srBsMu4/7BiDnN4fdedDYQNBYo019xZCZSstbhw3oX2o/A03+rYAcXz9F
 arFliQNlN0esKFVJ8qrOv7WoI2LK4vRiU7ZF8bRNtRxm6dBu+YjgFeG6XTWABDZKO77YxqbnwH6
 Gyo/ab6jGsYpuaixdhJ4S3HK62oGyPDqBpLjvAhNd7Dbz803XXp65nqMM6vkxLmeOfI4L/Jaw+w
 kC3GX7XqIfry+SoRTYwZqDGhUtLS2rWWGzHw38Z/Fxjjm+pe2KGrzccKhvOlWyl+OEoKhZpiSuf
 whVFKp3dJcUZQrY/5alJJ/X/B1TPfi0e20MEZbDZXJ0CJmryF0Q3uaOzhAQyJ7bVEWBAk9yYocU
 VxAlJy77jhDiPAhAH3w==
X-Proofpoint-GUID: 5GBmhDE29yLh0l5izIUJnSd2cL-8Ta33
X-Authority-Analysis: v=2.4 cv=bIsb4f+Z c=1 sm=1 tr=0 ts=69a1a38e cx=c_pps
 a=5HAIKLe1ejAbszaTRHs9Ug==:117 a=9tUHzIdeCh+UoOnba06Qjw==:17
 a=IkcTkHD0fZMA:10 a=HzLeVaNsDn8A:10 a=M51BFTxLslgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=gowsoOTTUOVcmtlkKump:22
 a=Byx-y9mGAAAA:8 a=EUspDBNiAAAA:8 a=p71xfkkELbvJglz7_8IA:9 a=QEXdDO2ut3YA:10
 a=gYDTvv6II1OnSo0itH1n:22
X-Proofpoint-ORIG-GUID: 5GBmhDE29yLh0l5izIUJnSd2cL-8Ta33
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-27_02,2026-02-27_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 spamscore=0 phishscore=0 impostorscore=0 suspectscore=0
 malwarescore=0 bulkscore=0 clxscore=1015 priorityscore=1501
 lowpriorityscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2602130000
 definitions=main-2602270124
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.87 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MIXED_CHARSET(0.79)[subject];
	DMARC_POLICY_ALLOW(-0.50)[qualcomm.com,reject];
	MV_CASE(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	R_DKIM_ALLOW(-0.20)[qualcomm.com:s=qcppdkim1,oss.qualcomm.com:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[16];
	TAGGED_FROM(0.00)[bounces-72155-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	FREEMAIL_TO(0.00)[163.com,brainfault.org,linux.dev,oss.qualcomm.com,microchip.com,sifive.com,hotmail.com,kernel.org,dabbelt.com,eecs.berkeley.edu,ghiti.fr];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[qualcomm.com:+,oss.qualcomm.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[qualcomm.com:email,qualcomm.com:dkim,oss.qualcomm.com:mid,oss.qualcomm.com:dkim,sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[radim.krcmar@oss.qualcomm.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_SOME(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCVD_COUNT_SEVEN(0.00)[7]
X-Rspamd-Queue-Id: D79AE1B8BC1
X-Rspamd-Action: no action

2026-02-27T20:10:08+08:00, Jinyu Tang <tjytimi@163.com>:
> Currently, kvm_arch_vcpu_load() unconditionally restores guest CSRs,
> HGATP, and AIA state. However, when a VCPU is loaded back on the same
> physical CPU, and no other KVM VCPU has run on this CPU since it was
> last put, the hardware CSRs and AIA registers are still valid.
>
> This patch optimizes the vcpu_load path by skipping the expensive CSR
> and AIA writes if all the following conditions are met:
> 1. It is being reloaded on the same CPU (vcpu->arch.last_exit_cpu =3D=3D =
cpu).
> 2. The CSRs are not dirty (!vcpu->arch.csr_dirty).
> 3. No other VCPU used this CPU (vcpu =3D=3D __this_cpu_read(kvm_former_vc=
pu)).
>
> To ensure this fast-path doesn't break corner cases:
> - Live migration and VCPU reset are naturally safe. KVM initializes
>   last_exit_cpu to -1, which guarantees the fast-path won't trigger.
> - The 'csr_dirty' flag tracks runtime userspace interventions. If
>   userspace modifies guest configurations (e.g., hedeleg via
>   KVM_SET_GUEST_DEBUG, or CSRs including AIA via KVM_SET_ONE_REG),
>   the flag is set to skip the fast path.
>
> With the 'csr_dirty' safeguard proven effective, it is safe to
> include kvm_riscv_vcpu_aia_load() inside the skip logic now.
>
> Signed-off-by: Jinyu Tang <tjytimi@163.com>
> ---
>  v6 -> v7:
>  - Moved kvm_riscv_vcpu_aia_load() into the fast-path skip logic, as
>    suggested by Radim Kr=C4=8Dm=C3=A1=C5=99.
>  - Verified the fix for the IMSIC instability issue reported in v3.
>    Testing was conducted on QEMU 10.0.2 with explicitly enabled AIA
>    (`-machine virt,aia=3Daplic-imsic`). The guest boots successfully=20
>    using virtio-mmio devices like virtio-blk and virtio-net.

Reviewed-by: Radim Kr=C4=8Dm=C3=A1=C5=99 <radim.krcmar@oss.qualcomm.com>

Thanks.

