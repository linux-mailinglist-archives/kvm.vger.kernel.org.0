Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 596144AC23D
	for <lists+kvm@lfdr.de>; Mon,  7 Feb 2022 16:01:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357141AbiBGO6F (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Feb 2022 09:58:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1442386AbiBGOuD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Feb 2022 09:50:03 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 530DDC0401C1;
        Mon,  7 Feb 2022 06:50:03 -0800 (PST)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 217DsU4c009698;
        Mon, 7 Feb 2022 14:50:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=g573CcFbfs0s4wW1z2wLmTrb8XZv6WBjGjEO7RDJLuo=;
 b=cHFRU7f/IS8p7w2Y21k0C53KOApK8G3QRaC17dpO0fkPhOhAN6DVUHN2KuliMNKMoLY0
 AqcXbpGxoSI2YJmbS4jgJ0YjAc0GpXqe482tv7nSG3ndUW3rPgLGuDq8smycGhTKwzrh
 tiGQ0qmNz+d1A79mxYFLDM5qZMWsvMTxAne9ujwcR6nPtK71yAtHHNGBxN2T1xUBYkun
 wrUx//8BI+cY1r4RpzWfmeY1Btou9NedgbuczrK6/WhrZ/IPajA0EyOHC5NXC/EfvalR
 WUPX2yiHU2Aom99KyKrer+xPVlJuoktEgSEGtHC9DzIwK2BqifUXQrMVP5x3zfzxQa0q xA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e22q0xhyq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Feb 2022 14:50:02 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 217EBTSd023357;
        Mon, 7 Feb 2022 14:50:02 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e22q0xhxx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Feb 2022 14:50:02 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 217EmTH7028159;
        Mon, 7 Feb 2022 14:50:00 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma03ams.nl.ibm.com with ESMTP id 3e1gv95tfy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Feb 2022 14:50:00 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 217EnuS945744602
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 7 Feb 2022 14:49:57 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D56134204D;
        Mon,  7 Feb 2022 14:49:56 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3A7D042042;
        Mon,  7 Feb 2022 14:49:56 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.11.12])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  7 Feb 2022 14:49:56 +0000 (GMT)
Date:   Mon, 7 Feb 2022 15:49:54 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Heiko Carstens <hca@linux.ibm.com>
Cc:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org,
        borntraeger@de.ibm.com, thuth@redhat.com, pasic@linux.ibm.com,
        david@redhat.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, scgl@linux.ibm.com
Subject: Re: [PATCH v7 01/17] KVM: s390: pv: leak the topmost page table
 when destroy fails
Message-ID: <20220207154954.52492029@p-imbrenda>
In-Reply-To: <YgEtq1i3K3ZkPpEX@osiris>
References: <20220204155349.63238-1-imbrenda@linux.ibm.com>
        <20220204155349.63238-2-imbrenda@linux.ibm.com>
        <0939aac3-9427-ed04-17e4-3c1e4195d509@linux.ibm.com>
        <YgEtq1i3K3ZkPpEX@osiris>
Organization: IBM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: jLWkRWNQd2OpDjO8SsZimqRobGt9MSRh
X-Proofpoint-ORIG-GUID: 0bnFswUWAYvvTgWUnAiGFUw9vAPZZ8ES
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-07_05,2022-02-07_02,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 malwarescore=0 suspectscore=0 priorityscore=1501 mlxlogscore=999
 clxscore=1015 adultscore=0 bulkscore=0 mlxscore=0 spamscore=0
 impostorscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2201110000 definitions=main-2202070093
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 7 Feb 2022 15:33:15 +0100
Heiko Carstens <hca@linux.ibm.com> wrote:

> > > +	asce = (gmap->asce & ~PAGE_MASK) | __pa(table);  
> > 
> > Please add a comment:
> > Set the new table origin while preserving ASCE control bits like table type
> > and length.  
> 
> And while touching this anyway, please make use of _ASCE_ORIGIN
> instead of PAGE_MASK.

will fix
