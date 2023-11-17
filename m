Return-Path: <kvm+bounces-1972-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4FB277EF63F
	for <lists+kvm@lfdr.de>; Fri, 17 Nov 2023 17:31:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7F7411C20A39
	for <lists+kvm@lfdr.de>; Fri, 17 Nov 2023 16:31:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C5D3D43148;
	Fri, 17 Nov 2023 16:31:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="dr4WI0dq"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E0C9194;
	Fri, 17 Nov 2023 08:31:38 -0800 (PST)
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3AHGVT6r019521;
	Fri, 17 Nov 2023 16:31:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=wm5ryiHQV4ceYmuxDgoEma8QWGQGtnYPeTR9T8q0Eu8=;
 b=dr4WI0dqUX7PtdMcz7xFcmEuPU14ViV7OYModKRvKKTofO4mmFAK220q9eoYR1VLELo5
 yQ0A2tBRCXGCz6tXeFqY5CSEf5mC3D5FNFsFVuWwAEcpuxfxsjFTc1srkwg8sFhcfF87
 /egnSEiZia1SrBONbmpJwnuyEEEaAC3d3QxYFtndgo4zwmKT9lb1vEco+QkQWS40X1NI
 LE89mpMHM3ZlhAfpR696XuYYnjtOkfarz4bUWu16BeKZkvJFPyUfO2vhB2Rnz02gHLUN
 5x4DyPO0iojB2/Jf3z9Eer+zl1eY4HuU0+lOPNGSXTVquyLvqfysrWpB5SjoGihPbKoF uw== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3uebbarufc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 17 Nov 2023 16:31:37 +0000
Received: from m0360083.ppops.net (m0360083.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3AHGVX0M020597;
	Fri, 17 Nov 2023 16:31:33 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3uebbaru73-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 17 Nov 2023 16:31:33 +0000
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3AHG46fc012347;
	Fri, 17 Nov 2023 16:27:28 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3uamayyeee-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 17 Nov 2023 16:27:28 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3AHGRPei62718318
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 17 Nov 2023 16:27:25 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 85B9E20040;
	Fri, 17 Nov 2023 16:27:25 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E868F20043;
	Fri, 17 Nov 2023 16:27:23 +0000 (GMT)
Received: from li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com (unknown [9.171.53.3])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Fri, 17 Nov 2023 16:27:23 +0000 (GMT)
Date: Fri, 17 Nov 2023 17:27:22 +0100
From: Alexander Gordeev <agordeev@linux.ibm.com>
To: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Tony Krowiak <akrowiak@linux.ibm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        jjherne@linux.ibm.com, pasic@linux.ibm.com, frankja@linux.ibm.com,
        imbrenda@linux.ibm.com, david@redhat.com
Subject: Re: [PATCH v3 0/3] s390/vfio-ap: a couple of corrections to the IRQ
 enablement function
Message-ID: <ZVeUaulw2GEOvmLi@li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com>
References: <20231109164427.460493-1-akrowiak@linux.ibm.com>
 <ZVTV37wqwu8cDmK7@li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com>
 <602a4845-726d-e034-bd77-20be1ff1d491@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <602a4845-726d-e034-bd77-20be1ff1d491@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: O8jCWJeRv0sbic-0izSdVv0bx4qWtLhQ
X-Proofpoint-ORIG-GUID: 0Ob_N0jmjBAB3u8eFgbXp-uDQB6kKbkR
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-17_15,2023-11-17_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 bulkscore=0
 priorityscore=1501 suspectscore=0 malwarescore=0 adultscore=0
 lowpriorityscore=0 clxscore=1015 impostorscore=0 spamscore=0
 mlxlogscore=522 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2311060000 definitions=main-2311170124

On Fri, Nov 17, 2023 at 04:31:49PM +0100, Christian Borntraeger wrote:
> Alexander, can you take those patches?

Applied, thanks!

> Christian

