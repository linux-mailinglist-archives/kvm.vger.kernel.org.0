Return-Path: <kvm+bounces-20606-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D799091A698
	for <lists+kvm@lfdr.de>; Thu, 27 Jun 2024 14:33:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8E3071F21D8B
	for <lists+kvm@lfdr.de>; Thu, 27 Jun 2024 12:33:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 411B515ECE9;
	Thu, 27 Jun 2024 12:33:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Fl6vASMj"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E62AC15A85D;
	Thu, 27 Jun 2024 12:33:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719491583; cv=none; b=fuQX0RLOSLCX3C3MJ11DX8AurEIm9gDQh6XmDNxk8xGFa2nVGXp4y5VtqAmA9Uopc/4MIXtB5pUlFiZY+QodVWfWvxSKfKgw4cDtiv7vQ1g2KGZgVA4hf2e2v6QGb/ceL8rd6CR+qJJLMeYB9QtM0mCcRnKKXBU24uPv38DgaYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719491583; c=relaxed/simple;
	bh=x9T2r+7WplUtpSVJLO9FU1G2C91jcztsP3Fv2uwkp7Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=g625oRoLE7DmLfLcw/6FUZkDFuB8KD4AJAKp9jbDRbBMl1pOYb9USk4Go5MVIZQWUoWsICzaaVJ6MsDOSPW3Hsd+BqncQc2WHFGyv3RfnjAQvhoOy9Q8pfbYGGjReemSxYgozvoPVdxx6W0zILf5c1z/dJkeYE7jL51bEuI3Wv0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=Fl6vASMj; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45RBvVC2015969;
	Thu, 27 Jun 2024 12:33:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=
	message-id:date:mime-version:subject:to:cc:references:from
	:in-reply-to:content-type:content-transfer-encoding; s=pp1; bh=x
	9T2r+7WplUtpSVJLO9FU1G2C91jcztsP3Fv2uwkp7Y=; b=Fl6vASMjiuaCiidR6
	aaHso5KU82qQZXXUQfj/Rujf+1L2drEjdTCW8Bt3BuV/RXotLM2LrM3Meu2rfhwE
	K/tFdB37w3COwWHUe+ynO7roTEqe/YnMQrwfb80ZNEMcZ7KketBZaQt/BNdDsoxc
	khLLryT8TaynvBlw7arxnY4qa0XHqEBS+AB9To45C/qaqBXGkBeRfbvpW81W9/W1
	czOsIEpXlVivp94QunOhRWhWqyxgQx3H/uftrfHH+u/8WuVfdeyU6OnOQwJ1Op76
	/53FpMY0Vg2UC9qgCA9wElGJTiIzEMamhwPeS/d8SVyZDFuAWu6MMcoFt4GHrMfI
	KDalg==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4014ks8jab-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 27 Jun 2024 12:32:59 +0000 (GMT)
Received: from m0356517.ppops.net (m0356517.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 45RCWxPC006198;
	Thu, 27 Jun 2024 12:32:59 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4014ks8ja8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 27 Jun 2024 12:32:59 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 45RC9RFB000575;
	Thu, 27 Jun 2024 12:32:57 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3yxaenakyq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 27 Jun 2024 12:32:57 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 45RCWp9753215530
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 27 Jun 2024 12:32:54 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D893B2004D;
	Thu, 27 Jun 2024 12:32:51 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5BB4320040;
	Thu, 27 Jun 2024 12:32:51 +0000 (GMT)
Received: from [9.171.15.243] (unknown [9.171.15.243])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 27 Jun 2024 12:32:51 +0000 (GMT)
Message-ID: <35cb7d12-d93b-4fbb-98fe-10ce2e6358f2@linux.ibm.com>
Date: Thu, 27 Jun 2024 14:32:51 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] s390/kvm: Reject memory region operations for ucontrol
 VMs
To: Paolo Bonzini <pbonzini@redhat.com>,
        Christoph Schlameuss <schlameuss@linux.ibm.com>
Cc: linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>, Jonathan Corbet <corbet@lwn.net>,
        linux-doc@vger.kernel.org
References: <20240624095902.29375-1-schlameuss@linux.ibm.com>
 <CABgObfYxZZdwe94u7OvHPUx+u4fDEJLnBEQbk1hdYs_Zy0D2hA@mail.gmail.com>
Content-Language: en-US
From: Janosch Frank <frankja@linux.ibm.com>
Autocrypt: addr=frankja@linux.ibm.com; keydata=
 xsFNBFubpD4BEADX0uhkRhkj2AVn7kI4IuPY3A8xKat0ihuPDXbynUC77mNox7yvK3X5QBO6
 qLqYr+qrG3buymJJRD9xkp4mqgasHdB5WR9MhXWKH08EvtvAMkEJLnqxgbqf8td3pCQ2cEpv
 15mH49iKSmlTcJ+PvJpGZcq/jE42u9/0YFHhozm8GfQdb9SOI/wBSsOqcXcLTUeAvbdqSBZe
 zuMRBivJQQI1esD9HuADmxdE7c4AeMlap9MvxvUtWk4ZJ/1Z3swMVCGzZb2Xg/9jZpLsyQzb
 lDbbTlEeyBACeED7DYLZI3d0SFKeJZ1SUyMmSOcr9zeSh4S4h4w8xgDDGmeDVygBQZa1HaoL
 Esb8Y4avOYIgYDhgkCh0nol7XQ5i/yKLtnNThubAcxNyryw1xSstnKlxPRoxtqTsxMAiSekk
 0m3WJwvwd1s878HrQNK0orWd8BzzlSswzjNfQYLF466JOjHPWFOok9pzRs+ucrs6MUwDJj0S
 cITWU9Rxb04XyigY4XmZ8dywaxwi2ZVTEg+MD+sPmRrTw+5F+sU83cUstuymF3w1GmyofgsU
 Z+/ldjToHnq21MNa1wx0lCEipCCyE/8K9B9bg9pUwy5lfx7yORP3JuAUfCYb8DVSHWBPHKNj
 HTOLb2g2UT65AjZEQE95U2AY9iYm5usMqaWD39pAHfhC09/7NQARAQABzSVKYW5vc2NoIEZy
 YW5rIDxmcmFua2phQGxpbnV4LmlibS5jb20+wsF3BBMBCAAhBQJbm6Q+AhsjBQsJCAcCBhUI
 CQoLAgQWAgMBAh4BAheAAAoJEONU5rjiOLn4p9gQALjkdj5euJVI2nNT3/IAxAhQSmRhPEt0
 AmnCYnuTcHRWPujNr5kqgtyER9+EMQ0ZkX44JU2q7OWxTdSNSAN/5Z7qmOR9JySvDOf4d3mS
 bMB5zxL9d8SbnSs1uW96H9ZBTlTQnmLfsiM9TetAjSrR8nUmjGhe2YUhJLR1v1LguME+YseT
 eXnLzIzqqpu311/eYiiIGcmaOjPCE+vFjcXL5oLnGUE73qSYiujwhfPCCUK0850o1fUAYq5p
 CNBCoKT4OddZR+0itKc/cT6NwEDwdokeg0+rAhxb4Rv5oFO70lziBplEjOxu3dqgIKbHbjza
 EXTb+mr7VI9O4tTdqrwJo2q9zLqqOfDBi7NDvZFLzaCewhbdEpDYVu6/WxprAY94hY3F4trT
 rQMHJKQENtF6ZTQc9fcT5I3gAmP+OEvDE5hcTALpWm6Z6SzxO7gEYCnF+qGXqp8sJVrweMub
 UscyLqHoqdZC2UG4LQ1OJ97nzDpIRe0g6oJ9ZIYHKmfw5jjwH6rASTld5MFWajWdNsqK15k/
 RZnHAGICKVIBOBsq26m4EsBlfCdt3b/6emuBjUXR1pyjHMz2awWzCq6/6OWs5eANZ0sdosNq
 dq2v0ULYTazJz2rlCXV89qRa7ukkNwdBSZNEwsD4eEMicj1LSrqWDZMAALw50L4jxaMD7lPL
 jJbazsFNBFubpD4BEADAcUTRqXF/aY53OSH7IwIK9lFKxIm0IoFkOEh7LMfp7FGzaP7ANrZd
 cIzhZi38xyOkcaFY+npGEWvko7rlIAn0JpBO4x3hfhmhBD/WSY8LQIFQNNjEm3vzrMo7b9Jb
 JAqQxfbURY3Dql3GUzeWTG9uaJ00u+EEPlY8zcVShDltIl5PLih20e8xgTnNzx5c110lQSu0
 iZv2lAE6DM+2bJQTsMSYiwKlwTuv9LI9Chnoo6+tsN55NqyMxYqJgElk3VzlTXSr3+rtSCwf
 tq2cinETbzxc1XuhIX6pu/aCGnNfuEkM34b7G1D6CPzDMqokNFbyoO6DQ1+fW6c5gctXg/lZ
 602iEl4C4rgcr3+EpfoPUWzKeM8JXv5Kpq4YDxhvbitr8Dm8gr38+UKFZKlWLlwhQ56r/zAU
 v6LIsm11GmFs2/cmgD1bqBTNHHcTWwWtRTLgmnqJbVisMJuYJt4KNPqphTWsPY8SEtbufIlY
 HXOJ2lqUzOReTrie2u0qcSvGAbSfec9apTFl2Xko/ddqPcZMpKhBiXmY8tJzSPk3+G4tqur4
 6TYAm5ouitJsgAR61Cu7s+PNuq/pTLDhK+6/Njmc94NGBcRA4qTuysEGE79vYWP2oIAU4Fv6
 gqaWHZ4MEI2XTqH8wiwzPdCQPYsSE0fXWiYu7ObeErT6iLSTZGx4rQARAQABwsFfBBgBCAAJ
 BQJbm6Q+AhsMAAoJEONU5rjiOLn4DDEP/RuyckW65SZcPG4cMfNgWxZF8rVjeVl/9PBfy01K
 8R0hajU40bWtXSMiby7j0/dMjz99jN6L+AJHJvrLz4qYRzn2Ys843W+RfXj62Zde4YNBE5SL
 jJweRCbMWKaJLj6499fctxTyeb9+AMLQS4yRSwHuAZLmAb5AyCW1gBcTWZb8ON5BmWnRqeGm
 IgC1EvCnHy++aBnHTn0m+zV89BhTLTUal35tcjUFwluBY39R2ux/HNlBO1GY3Z+WYXhBvq7q
 katThLjaQSmnOrMhzqYmdShP1leFTVbzXUUIYv/GbynO/YrL2gaQpaP1bEUEi8lUAfXJbEWG
 dnHFkciryi092E8/9j89DJg4mmZqOau7TtUxjRMlBcIliXkzSLUk+QvD4LK1kWievJse4mte
 FBdkWHfP4BH/+8DxapRcG1UAheSnSRQ5LiO50annOB7oXF+vgKIaie2TBfZxQNGAs3RQ+bga
 DchCqFm5adiSP5+OT4NjkKUeGpBe/aRyQSle/RropTgCi85pje/juYEn2P9UAgkfBJrOHvQ9
 Z+2Sva8FRd61NJLkCJ4LFumRn9wQlX2icFbi8UDV3do0hXJRRYTWCxrHscMhkrFWLhYiPF4i
 phX7UNdOWBQ90qpHyAxHmDazdo27gEjfvsgYMdveKknEOTEb5phwxWgg7BcIDoJf9UMC
In-Reply-To: <CABgObfYxZZdwe94u7OvHPUx+u4fDEJLnBEQbk1hdYs_Zy0D2hA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: mTn_dzUG9zRzJmu037-Ihe_DndbX9W86
X-Proofpoint-ORIG-GUID: BGyRQszkQYBqJAbx0pOSe03aKiALIM1c
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-27_06,2024-06-27_03,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 spamscore=0
 suspectscore=0 phishscore=0 priorityscore=1501 mlxlogscore=646
 clxscore=1015 malwarescore=0 lowpriorityscore=0 bulkscore=0 adultscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2406140001 definitions=main-2406270094

T24gNi8yNy8yNCAxMzo1MywgUGFvbG8gQm9uemluaSB3cm90ZToNCj4gT24gTW9uLCBKdW4g
MjQsIDIwMjQgYXQgMTE6NTnigK9BTSBDaHJpc3RvcGggU2NobGFtZXVzcw0KPiA8c2NobGFt
ZXVzc0BsaW51eC5pYm0uY29tPiB3cm90ZToNCj4+DQo+PiBUaGlzIGNoYW5nZSByZWplY3Rz
IHRoZSBLVk1fU0VUX1VTRVJfTUVNT1JZX1JFR0lPTiBhbmQNCj4+IEtWTV9TRVRfVVNFUl9N
RU1PUllfUkVHSU9OMiBpb2N0bHMgd2hlbiBjYWxsZWQgb24gYSB1Y29udHJvbCBWTS4NCj4+
IFRoaXMgaXMgbmVjY2Vzc2FyeSBzaW5jZSB1Y29udHJvbCBWTXMgaGF2ZSBrdm0tPmFyY2gu
Z21hcCBzZXQgdG8gMCBhbmQNCj4+IHdvdWxkIHRodXMgcmVzdWx0IGluIGEgbnVsbCBwb2lu
dGVyIGRlcmVmZXJlbmNlIGZ1cnRoZXIgaW4uDQo+PiBNZW1vcnkgbWFuYWdlbWVudCBuZWVk
cyB0byBiZSBwZXJmb3JtZWQgaW4gdXNlcnNwYWNlIGFuZCB1c2luZyB0aGUNCj4+IGlvY3Rs
cyBLVk1fUzM5MF9VQ0FTX01BUCBhbmQgS1ZNX1MzOTBfVUNBU19VTk1BUC4NCj4+DQo+PiBB
bHNvIGltcHJvdmUgczM5MCBzcGVjaWZpYyBkb2N1bWVudGF0aW9uIGZvciBLVk1fU0VUX1VT
RVJfTUVNT1JZX1JFR0lPTg0KPj4gYW5kIEtWTV9TRVRfVVNFUl9NRU1PUllfUkVHSU9OMi4N
Cj4gDQo+IFdvdWxkIGJlIG5pY2UgdG8gaGF2ZSBhIHNlbGZ0ZXN0IGZvciB1Y29udHJvbCBW
TXMsIHRvby4uLiBqdXN0IHNheWluZyA6KQ0KPiANCj4gUGFvbG8NCj4gDQoNCkFscmVhZHkg
aW4gdGhlIHdvcmtzLCBoZSBqdXN0IGhhc24ndCBwb3N0ZWQgaXQgeWV0IDopDQpXZSBkaWQg
ZG8gYSBjb3VwbGUgcm91bmRzIG9mIGludGVybmFsIGZlZWRiYWNrIG9uIHRoZSB0ZXN0cyBm
aXJzdC4NCg==

