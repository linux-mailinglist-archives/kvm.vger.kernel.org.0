Return-Path: <kvm+bounces-36422-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 99BDAA1A9E4
	for <lists+kvm@lfdr.de>; Thu, 23 Jan 2025 20:01:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C8B86169A23
	for <lists+kvm@lfdr.de>; Thu, 23 Jan 2025 19:01:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3F844156991;
	Thu, 23 Jan 2025 19:01:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="YRSmz/GS"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F30EB84A30
	for <kvm@vger.kernel.org>; Thu, 23 Jan 2025 19:01:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737658885; cv=none; b=ogM2m3MWRljwnKbFXL5VUMl4wRekZSxmke07MD/+M10DqiZLWqOYr83kMY7FVk/fdmUPOoT7x1WfBUo3GfhyzpJ6kIim2AUAZCmMsxTD+S8pORS+0Yw95+oWZCEw8SR0YjH92VhU3ZFSulTxUB4bmKJI9SmpLS0vXbLkEi6MyhY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737658885; c=relaxed/simple;
	bh=jQOsZa1kPP0SBZb3wwO9LdxBn4v9a8URyJL+JaaugcU=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=ptTP9wc/o0V3GWEAj81OsKmIoUhPRg8e2A1jOtOGxYJRCN6BQhxHhzSyHHfex/bexkhkV0rDTepbjoXxW4uhHKPYbJdgiDEapEyzb1LYsNWrmfLlfNYVnApoE8th0gg+DInuCB49i3/FNR9rAarRaa3//3zEizO1qI9Xx0rlp6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=YRSmz/GS; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50NBIKaa022537;
	Thu, 23 Jan 2025 19:01:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=
	content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=pp1; bh=jQOsZa1kPP0SBZb3wwO9LdxBn4v9
	a8URyJL+JaaugcU=; b=YRSmz/GSTUdSV8GUFHJ+JyQEeHTVHnnQofCuN7B2wh/U
	59++rMnU70I+nm1MwRWZ58Vk0+90xqgXzMYYcnnUuZz1mxsuVAoaiExF7P9UwzEg
	HA8J6eCdDMPtEs7wpasTYjMRmkrdONcZbAmPooEfkxUYIJEPM6O2t4LaFwHgW3NE
	aat1Eq5AVJDxb9SejV4RrqEkLfXQlQz2811xVI/H5JpWQJUsJf1yrf6vS3WLl06K
	qeSA56mK787wAl/mAWNHP+dpwBnJCJccnU817VOSSM2PiAak1a3TGRa+V1wxm8yO
	YLPUnLQS9ID+LRbLEIG4xrsLXuALB3HN6d+8uF74Rw==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 44bbu9cu3y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 23 Jan 2025 19:01:17 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 50NGvemI021074;
	Thu, 23 Jan 2025 19:01:17 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 448sb1pmfp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 23 Jan 2025 19:01:16 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 50NJ1Fob22020546
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 23 Jan 2025 19:01:15 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6527520043;
	Thu, 23 Jan 2025 19:01:15 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2C9AE20040;
	Thu, 23 Jan 2025 19:01:15 +0000 (GMT)
Received: from [9.171.56.106] (unknown [9.171.56.106])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 23 Jan 2025 19:01:15 +0000 (GMT)
Message-ID: <ea6e5059-85d1-4503-99d4-635272b9b32b@linux.ibm.com>
Date: Thu, 23 Jan 2025 20:01:14 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: kvm list <kvm@vger.kernel.org>, qemu-devel <qemu-devel@nongnu.org>
From: Christian Borntraeger <borntraeger@linux.ibm.com>
Subject: Save the date: KVM Forum 2025, Milan, Italy, September 4-5
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: gLzQ5-PW3urjwUkrNy0UXLByViLDpFcf
X-Proofpoint-ORIG-GUID: gLzQ5-PW3urjwUkrNy0UXLByViLDpFcf
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-23_08,2025-01-23_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=623
 priorityscore=1501 clxscore=1015 adultscore=0 bulkscore=0 mlxscore=0
 suspectscore=0 malwarescore=0 impostorscore=0 lowpriorityscore=0
 spamscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2411120000 definitions=main-2501230135

###################
KVM Forum 2025
September 4-5, 2025
Milan, Italy
###################

On behalf of the program committee for the KVM Forum, I am pleased to announce
KVM Forum 2025, September 4-5 2025 in Milan Italy.
The call for papers will follow, but we want to give you the opportunity
to pre-plan.

https://kvm-forum.qemu.org/ and https://kvm-forum.qemu.org/location/
already provide some initial information, more will come soon.

Christian Bornträger

