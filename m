Return-Path: <kvm+bounces-464-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1F6B87DFF3E
	for <lists+kvm@lfdr.de>; Fri,  3 Nov 2023 07:50:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C6A9A281DBE
	for <lists+kvm@lfdr.de>; Fri,  3 Nov 2023 06:50:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 43AA91FB9;
	Fri,  3 Nov 2023 06:50:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="U21P3Q2C"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A4A57E
	for <kvm@vger.kernel.org>; Fri,  3 Nov 2023 06:50:45 +0000 (UTC)
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1871F1B2
	for <kvm@vger.kernel.org>; Thu,  2 Nov 2023 23:50:44 -0700 (PDT)
Received: from pps.filterd (m0353723.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3A36jGnx010628
	for <kvm@vger.kernel.org>; Fri, 3 Nov 2023 06:50:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=content-type :
 mime-version : content-transfer-encoding : in-reply-to : references :
 subject : from : to : cc : message-id : date; s=pp1;
 bh=f5BKQD7Mhlo2Obl1C+UZBzk9SarzwG1VRM2I/mDQxV0=;
 b=U21P3Q2C7H2b08dWtd0SkekORmMftIaJkbQUhaXjwXlukqfj91WfOyyngJAqbMBO4jQN
 egWjDBBw3zOnubZL0LJcSBx661Dox082bt8i3jdiR/LDsIWpO4ZRhbTUojBuB71aSheQ
 khmuFo0t438/S8muSX4dDQimsl8ofYfbFBNq+NURNHHBaReW4EG6eAei3AnL51n/PVd+
 p38wBvNxkAEsc+ijKG+dp+iTMtOeEpn84lPNgqoeyslDtpDO3T2M53X0i5cqVUHP0XFf
 vmmK36rYA6GEGulBgFwPNXuiky7F/D7GcXyU4unK5lwP1GwV1R8pAczWQlwSaK42Sm9y Ew== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3u4uv3r567-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
	for <kvm@vger.kernel.org>; Fri, 03 Nov 2023 06:50:43 +0000
Received: from m0353723.ppops.net (m0353723.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3A36k2Ad013458
	for <kvm@vger.kernel.org>; Fri, 3 Nov 2023 06:50:42 GMT
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3u4uv3r55g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 03 Nov 2023 06:50:42 +0000
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3A34TN0c011291;
	Fri, 3 Nov 2023 06:50:42 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 3u1eukktf9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 03 Nov 2023 06:50:41 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3A36ocN744565024
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 3 Nov 2023 06:50:38 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 14E8D20043;
	Fri,  3 Nov 2023 06:50:38 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6F10220040;
	Fri,  3 Nov 2023 06:50:37 +0000 (GMT)
Received: from t14-nrb (unknown [9.171.63.94])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri,  3 Nov 2023 06:50:37 +0000 (GMT)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20231102153549.53984-1-imbrenda@linux.ibm.com>
References: <20231102153549.53984-1-imbrenda@linux.ibm.com>
Subject: Re: [PATCH v2 1/1] KVM: s390: vsie: fix wrong VIR 37 when MSO is used
From: Nico Boehr <nrb@linux.ibm.com>
To: Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org
Cc: nsg@linux.ibm.com, borntraeger@de.ibm.com, frankja@linux.ibm.com,
        david@redhat.com
Message-ID: <169899423609.24043.3575763809767310289@t14-nrb>
User-Agent: alot/0.8.1
Date: Fri, 03 Nov 2023 07:50:36 +0100
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: YzoM9KN5WjzIx4h0nyn7ZbbCoGJO51Bl
X-Proofpoint-GUID: ZKamiED7TYt7cPE7lYv0LnO628Ev1-x0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-03_06,2023-11-02_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 spamscore=0
 lowpriorityscore=0 mlxscore=0 phishscore=0 adultscore=0 bulkscore=0
 suspectscore=0 mlxlogscore=784 priorityscore=1501 impostorscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2310240000 definitions=main-2311030054

Quoting Claudio Imbrenda (2023-11-02 16:35:49)
> When the host invalidates a guest page, it will also check if the page
> was used to map the prefix of any guest CPUs, in which case they are
> stopped and marked as needing a prefix refresh. Upon starting the
> affected CPUs again, their prefix pages are explicitly faulted in and
> revalidated if they had been invalidated. A bit in the PGSTEs indicates
> whether or not a page might contain a prefix. The bit is allowed to
> overindicate. Pages above 2G are skipped, because they cannot be
> prefixes, since KVM runs all guests with MSO =3D 0.
>=20
> The same applies for nested guests (VSIE). When the host invalidates a
> guest page that maps the prefix of the nested guest, it has to stop the
> affected nested guest CPUs and mark them as needing a prefix refresh.
> The same PGSTE bit used for the guest prefix is also used for the
> nested guest. Pages above 2G are skipped like for normal guests, which
> is the source of the bug.
>=20
> The nested guest runs is the guest primary address space. The guest
> could be running the nested guest using MSO !=3D 0. If the MSO + prefix
> for the nested guest is above 2G, the check for nested prefix will skip
> it. This will cause the invalidation notifier to not stop the CPUs of
> the nested guest and not mark them as needing refresh. When the nested
> guest is run again, its prefix will not be refreshed, since it has not
> been marked for refresh. This will cause a fatal validity intercept
> with VIR code 37.
>=20
> Fix this by removing the check for 2G for nested guests. Now all
> invalidations of pages with the notify bit set will always scan the
> existing VSIE shadow state descriptors.
>=20
> This allows to catch invalidations of nested guest prefix mappings even
> when the prefix is above 2G in the guest virtual address space.
>=20
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

Tested-by: Nico Boehr <nrb@linux.ibm.com>
Reviewed-by: Nico Boehr <nrb@linux.ibm.com>

