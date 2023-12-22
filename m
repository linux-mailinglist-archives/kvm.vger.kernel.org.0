Return-Path: <kvm+bounces-5159-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 926B581CC10
	for <lists+kvm@lfdr.de>; Fri, 22 Dec 2023 16:18:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C46001C21085
	for <lists+kvm@lfdr.de>; Fri, 22 Dec 2023 15:18:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 84EA82376E;
	Fri, 22 Dec 2023 15:18:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="KuM0vInl"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7E912374D;
	Fri, 22 Dec 2023 15:17:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3BME67DO010059;
	Fri, 22 Dec 2023 15:17:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=ZWrJsTYOoV29o/sIVqwxhwxPR262KH+d/Yci05WaoFA=;
 b=KuM0vInlBUnHa2qLXAc18v7cMikri79roF4vD7og7eHW0FR1lKtrF+35Ld1UfvHApS48
 uXFhhpZWo1HT9vNY5Y4MhXBZMmrA+CyfsiZsTEyUqyQOF5EoyanmG5gV4z0dhsWY+YXp
 w9ziYVQNz3PNL9o2/CtdG39EbDSQteTKQ5kvkJXCtueoZ4odFI9+nhCgOVbcEIGoNZHM
 9cup5FoINxx7iy4IubPuudXOkwyRHCskmSQDOLoKXWTUNx2sSIyT7v2OWMTrQdrOE7DW
 wwPc57ZgyCxZBEhAUHGaQy+o/zjp486elZULKlueig197SE/8adznSuYWguAwG3KXHnJ ag== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3v5afmkfqx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 22 Dec 2023 15:17:41 +0000
Received: from m0360083.ppops.net (m0360083.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3BMEEkoQ032205;
	Fri, 22 Dec 2023 15:17:40 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3v5afmkf61-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 22 Dec 2023 15:17:39 +0000
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3BMEk2Fr029718;
	Fri, 22 Dec 2023 15:16:03 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 3v1p7t45k8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 22 Dec 2023 15:16:02 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3BMFG0Xq19005978
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 22 Dec 2023 15:16:00 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1C39C2004F;
	Fri, 22 Dec 2023 15:16:00 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 49C7320043;
	Fri, 22 Dec 2023 15:15:59 +0000 (GMT)
Received: from p-imbrenda (unknown [9.179.5.15])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with SMTP;
	Fri, 22 Dec 2023 15:15:59 +0000 (GMT)
Date: Fri, 22 Dec 2023 16:04:14 +0100
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: Nicholas Piggin <npiggin@gmail.com>
Cc: Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org,
        Laurent Vivier
 <lvivier@redhat.com>,
        "Shaoqin Huang" <shahuang@redhat.com>,
        Andrew Jones
 <andrew.jones@linux.dev>, Nico Boehr <nrb@linux.ibm.com>,
        Paolo Bonzini
 <pbonzini@redhat.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Eric
 Auger <eric.auger@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David
 Hildenbrand <david@redhat.com>, linuxppc-dev@lists.ozlabs.org,
        linux-s390@vger.kernel.org, kvmarm@lists.linux.dev
Subject: Re: [kvm-unit-tests PATCH 1/9] s390x: clean lib/auxinfo.o
Message-ID: <20231222160414.5175ebba@p-imbrenda>
In-Reply-To: <20231222135048.1924672-2-npiggin@gmail.com>
References: <20231222135048.1924672-1-npiggin@gmail.com>
	<20231222135048.1924672-2-npiggin@gmail.com>
Organization: IBM
X-Mailer: Claws Mail 4.2.0 (GTK 3.24.38; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: P7Ivpbc0jONApp_ZrCWAo_Kd26CGdaCl
X-Proofpoint-ORIG-GUID: MmZlGmYa-oSqI4DgF66gFF7_0WpynP8N
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.997,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-12-22_09,2023-12-21_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 priorityscore=1501
 spamscore=0 lowpriorityscore=0 suspectscore=0 impostorscore=0 adultscore=0
 phishscore=0 malwarescore=0 clxscore=1015 mlxlogscore=867 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311290000
 definitions=main-2312220112

On Fri, 22 Dec 2023 23:50:40 +1000
Nicholas Piggin <npiggin@gmail.com> wrote:

> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
> ---
>  s390x/Makefile | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/s390x/Makefile b/s390x/Makefile
> index f79fd009..95ef9533 100644
> --- a/s390x/Makefile
> +++ b/s390x/Makefile
> @@ -227,7 +227,7 @@ $(snippet_asmlib): $$(patsubst %.o,%.S,$$@) $(asm-offsets)
>  
>  
>  arch_clean: asm_offsets_clean
> -	$(RM) $(TEST_DIR)/*.{o,elf,bin,lds} $(SNIPPET_DIR)/*/*.{o,elf,*bin,*obj,hdr,lds} $(SNIPPET_DIR)/asm/.*.d $(TEST_DIR)/.*.d lib/s390x/.*.d $(comm-key)
> +	$(RM) $(TEST_DIR)/*.{o,elf,bin,lds} $(SNIPPET_DIR)/*/*.{o,elf,*bin,*obj,hdr,lds} $(SNIPPET_DIR)/asm/.*.d $(TEST_DIR)/.*.d lib/s390x/.*.d lib/auxinfo.o $(comm-key)

it seems other architectures don't need to do the cleanp? what are we
doing wrong?

>  
>  generated-files = $(asm-offsets)
>  $(tests:.elf=.o) $(asmlib) $(cflatobjs): $(generated-files)


