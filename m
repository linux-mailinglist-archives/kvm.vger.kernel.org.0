Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F6B353764D
	for <lists+kvm@lfdr.de>; Mon, 30 May 2022 10:13:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233173AbiE3IL4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 May 2022 04:11:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233125AbiE3ILs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 May 2022 04:11:48 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0DB0F47;
        Mon, 30 May 2022 01:11:43 -0700 (PDT)
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24U6nVp1015905;
        Mon, 30 May 2022 08:11:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=VIAjJqEzkS48zVmiLhW0Cuseh14NQVVk7EMZNm/V3kM=;
 b=CkXBUudzS/2KSjwKS9KW7kvdFWeZp+QPo9MhiRW4CdAEvPG1igc6/R51ukVSEnkgGi20
 Gubyj9BGU6xp7dQYDOUrLAufrAzhv3RfOhVsxHE+vdNXCoAnGRWaRzwxKbhHUp3xfUv6
 KCkuMsGR3NUqng6/hvUwRBUJtCK6gvPK3PDT/LDweWewMv3PiJOuoBWL2YfTc8DYiOmn
 /WAMwXE/QN3JPPKkANHfZT1tpcOzo2LRSI1EBMSHDADsAVwsILDgk6YrgWwFPr11Bb4X
 PKfLWQAcAmaPrRZx0wwNLxiWlJRUI/xcBgWYu72WxzvYYbGLIfHbmjV+CQx1CIedKHKv 9w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gcs0e9j3q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 30 May 2022 08:11:43 +0000
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 24U7FssP018503;
        Mon, 30 May 2022 08:11:42 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gcs0e9j2t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 30 May 2022 08:11:42 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24U85ssi011816;
        Mon, 30 May 2022 08:11:40 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma03fra.de.ibm.com with ESMTP id 3gbc97srrj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 30 May 2022 08:11:40 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24U8BcIn20775392
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 30 May 2022 08:11:38 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E80174203F;
        Mon, 30 May 2022 08:11:37 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5F6D642045;
        Mon, 30 May 2022 08:11:37 +0000 (GMT)
Received: from li-ca45c2cc-336f-11b2-a85c-c6e71de567f1.ibm.com (unknown [9.171.70.209])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 30 May 2022 08:11:37 +0000 (GMT)
Message-ID: <ff5f394db586169fe6dc16dc0e24d534e4825caa.camel@linux.ibm.com>
Subject: Re: [PATCH v10 14/19] KVM: s390: pv: cleanup leftover protected VMs
 if needed
From:   Nico Boehr <nrb@linux.ibm.com>
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org
Cc:     borntraeger@de.ibm.com, frankja@linux.ibm.com, thuth@redhat.com,
        pasic@linux.ibm.com, david@redhat.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, scgl@linux.ibm.com,
        mimu@linux.ibm.com
Date:   Mon, 30 May 2022 10:11:37 +0200
In-Reply-To: <20220414080311.1084834-15-imbrenda@linux.ibm.com>
References: <20220414080311.1084834-1-imbrenda@linux.ibm.com>
         <20220414080311.1084834-15-imbrenda@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.1 (3.44.1-1.fc36) 
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 3wkk6YIzroH11PyGEpAGH_HujTMraCg2
X-Proofpoint-GUID: 2suuD96DNGc5t-uCPwgeAy7rbtuPnfb6
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-30_02,2022-05-27_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 mlxscore=0
 suspectscore=0 malwarescore=0 lowpriorityscore=0 priorityscore=1501
 spamscore=0 adultscore=0 bulkscore=0 phishscore=0 mlxlogscore=999
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2205300042
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2022-04-14 at 10:03 +0200, Claudio Imbrenda wrote:
[...]
> diff --git a/arch/s390/kvm/pv.c b/arch/s390/kvm/pv.c
> index bd850be08c86..b20f2cbd43d9 100644
> --- a/arch/s390/kvm/pv.c
> +++ b/arch/s390/kvm/pv.c
> @@ -17,6 +17,19 @@
[...]
> +/**
> + * @struct deferred_priv
> + * Represents a "leftover" protected VM that is still registered
> with the
> + * Ultravisor, but which does not correspond any longer to an active
> KVM VM.
> + */
> +struct deferred_priv {

Why not just name this leftover_vm?

