Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CB3158F8A1
	for <lists+kvm@lfdr.de>; Thu, 11 Aug 2022 09:54:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234280AbiHKHys (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Aug 2022 03:54:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234307AbiHKHyp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Aug 2022 03:54:45 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2B998E993
        for <kvm@vger.kernel.org>; Thu, 11 Aug 2022 00:54:44 -0700 (PDT)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27B6iH6N026945
        for <kvm@vger.kernel.org>; Thu, 11 Aug 2022 07:54:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=content-type :
 mime-version : content-transfer-encoding : in-reply-to : references : to :
 from : subject : cc : message-id : date; s=pp1;
 bh=rYr+a4GvS/NBKYKhTdMu7oesP+H5CI3VpW7I/ptjvOI=;
 b=r718MaRPlqI3id/xb2+GEhDlrUZ8LwZl/MKz8NfF/4GNhUnFq7CPnSOWoT1kH2L+hRnI
 qf3GuHtheGIaDHNkTsEcfQAJfHlvHacLkzqePxRvq947NkX61cxWPL5T3mABrMPf5XjW
 sjxUbdkT29qAuPPTPgmzZu1U41zXxnRO05QtUBK0RUK3C235EBJJWy9dM0l3Xb5+tyJc
 CcamE77hEQeIhYZh+hueE3iAK7ujU9w0Sw6UmbHvlFWyoVrRUyE9lkWwl34s0hzdriCc
 ueN7y39IOwWdTpFJ9uqIqB64KxHeXlG19qv80lcLmPPniaVOeY4yRAQTr/cHhvVTzZIh 7Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hvvrphtd1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 11 Aug 2022 07:54:44 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 27B6iSE0031508
        for <kvm@vger.kernel.org>; Thu, 11 Aug 2022 07:54:44 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hvvrphtcc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 11 Aug 2022 07:54:43 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 27B7p884013896;
        Thu, 11 Aug 2022 07:54:41 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma06ams.nl.ibm.com with ESMTP id 3huwvf1q16-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 11 Aug 2022 07:54:41 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 27B7scJW32506188
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 11 Aug 2022 07:54:38 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 71E1E4203F;
        Thu, 11 Aug 2022 07:54:38 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4689042042;
        Thu, 11 Aug 2022 07:54:38 +0000 (GMT)
Received: from li-ca45c2cc-336f-11b2-a85c-c6e71de567f1.ibm.com (unknown [9.171.35.74])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 11 Aug 2022 07:54:38 +0000 (GMT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20220810151302.67aa3d3c@p-imbrenda>
References: <20220722060043.733796-1-nrb@linux.ibm.com> <20220722060043.733796-4-nrb@linux.ibm.com> <20220810120822.51ead12d@p-imbrenda> <166013456744.24812.12686537606143025741@localhost.localdomain> <20220810151302.67aa3d3c@p-imbrenda>
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
From:   Nico Boehr <nrb@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v3 3/4] s390x: add extint loop test
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, thuth@redhat.com
Message-ID: <166020447794.24812.2478143576932288604@localhost.localdomain>
User-Agent: alot/0.8.1
Date:   Thu, 11 Aug 2022 09:54:37 +0200
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: NH3phdTcDy4xPAoPdvSqsgIr4hOWiZQs
X-Proofpoint-ORIG-GUID: VUYYel9HfWiA-FrVQz2sMJWMP3QxahGB
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-11_03,2022-08-10_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 spamscore=0
 lowpriorityscore=0 clxscore=1015 phishscore=0 mlxscore=0 impostorscore=0
 suspectscore=0 bulkscore=0 priorityscore=1501 mlxlogscore=641
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2208110020
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Quoting Claudio Imbrenda (2022-08-10 15:13:02)
[...]
> just add a comment to explain that

Yes makes sense, thanks. I came up with this:

/*
 * When the interrupt loop occurs, this instruction will never be
 * executed.
 * In case the loop isn't triggered return to pgm_old_psw so we can fail
 * fast and don't have to rely on the kvm-unit-tests timeout.
 */
