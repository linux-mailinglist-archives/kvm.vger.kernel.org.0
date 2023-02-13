Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16391694675
	for <lists+kvm@lfdr.de>; Mon, 13 Feb 2023 14:02:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230503AbjBMNCK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Feb 2023 08:02:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230403AbjBMNCI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Feb 2023 08:02:08 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC16C1204B;
        Mon, 13 Feb 2023 05:02:06 -0800 (PST)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31DCidIN012449;
        Mon, 13 Feb 2023 13:02:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=content-type :
 mime-version : content-transfer-encoding : in-reply-to : references : to :
 subject : cc : from : message-id : date; s=pp1;
 bh=8RWQOwfThnmNV/Ln0Q/c9n9Ci7Pw6u1zxnd1mGlldpE=;
 b=dEezIHSZBSvM2SRsPqlvjf/zv9YtJdp5XM6QFrMPLHMVEfnG/9xXZ3t1PRdV6E08hLVj
 zm15n39HtGB7sTHyo5U/Q0t2vHOxvgU8jbsuGqXMZdDEh7xiGCcPqMArL3hH5vhqa2pY
 67Pbxa5v7o1we+PeXE6cpG1E1PfHjron017jdngENJsXym3B8KF8sqx7CAeII0MQqlHh
 a0PoVGsqnsfm2xmIjXFhkVyDe/ORqAkZaV0nwEV2JR32ctSZ33ZbLq1YZgHr7QLzHRK8
 ls0iYf369GM32gpFCOlW7vRujjNFS/MEvgiZPgbCYdVsFJqhON5iF78bmXnUDEYSRCJ0 +Q== 
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3nqnft0cnw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 13 Feb 2023 13:02:05 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 31D8B7Ii001601;
        Mon, 13 Feb 2023 13:02:04 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
        by ppma01fra.de.ibm.com (PPS) with ESMTPS id 3np2n6a03w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 13 Feb 2023 13:02:04 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
        by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 31DD20pG22610366
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 Feb 2023 13:02:00 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8A5CF2004F;
        Mon, 13 Feb 2023 13:02:00 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6C23E20043;
        Mon, 13 Feb 2023 13:02:00 +0000 (GMT)
Received: from t14-nrb (unknown [9.171.26.157])
        by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Mon, 13 Feb 2023 13:02:00 +0000 (GMT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <914807eb-ec75-0de1-abe4-2b928917edef@linux.ibm.com>
References: <20230213085520.100756-1-nrb@linux.ibm.com> <20230213085520.100756-2-nrb@linux.ibm.com> <38deba59-ac91-0196-d7f0-e7846a7531b3@linux.ibm.com> <914807eb-ec75-0de1-abe4-2b928917edef@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>, borntraeger@linux.ibm.com,
        imbrenda@linux.ibm.com
Subject: Re: [PATCH v3 1/1] KVM: s390: pv: fix external interruption loop not always detected
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
From:   Nico Boehr <nrb@linux.ibm.com>
Message-ID: <167629331966.23937.10957691359794018314@t14-nrb.local>
User-Agent: alot/0.8.1
Date:   Mon, 13 Feb 2023 14:02:00 +0100
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: PIiUoTwBmxCW50rK_9xUOhhXNp4Tj0TO
X-Proofpoint-ORIG-GUID: PIiUoTwBmxCW50rK_9xUOhhXNp4Tj0TO
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-13_07,2023-02-13_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 priorityscore=1501 mlxscore=0 suspectscore=0 lowpriorityscore=0
 spamscore=0 bulkscore=0 impostorscore=0 phishscore=0 malwarescore=0
 mlxlogscore=479 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2212070000 definitions=main-2302130112
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Quoting Janosch Frank (2023-02-13 13:00:25)
[...]
> I'll add this when picking:
> Fixes: 201ae986ead7 ("KVM: s390: protvirt: Implement interrupt injection")

Fine for me, thanks and sorry for the troubles.
