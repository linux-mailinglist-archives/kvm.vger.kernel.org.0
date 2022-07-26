Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7843758194E
	for <lists+kvm@lfdr.de>; Tue, 26 Jul 2022 20:04:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239711AbiGZSEn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Jul 2022 14:04:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239705AbiGZSEm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Jul 2022 14:04:42 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73DCC27FCC;
        Tue, 26 Jul 2022 11:04:41 -0700 (PDT)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26QHDoB9031422;
        Tue, 26 Jul 2022 18:03:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=ieTag46EF2a1y3ONSFB+R6UbnY+B4XHu7AaqRFiMjtg=;
 b=J4Ck2ju2JzM7Sh4CPpLDsikyw3MA57kIeq/mDkt7a2Uj2shqxpRRTywi2TnYlTQL/pQD
 eS0rAq64zEXIC1g8/fNw4+u+0np6XXvLLb133PRmhSmIuehiTnFhtsq628ng21yZuGUK
 OJwsU60eHpqEsangj58+uNiIW8/A998G841td7WutdfFVAGPmmGw7qDxvz+TE/6ZUrzm
 Kj6rABksAVJKqDbIr4zFJXo8t+E/CrQ9BppYA4PxSQ6aC8NxOWaY3cvQn3ZrW6+s2nYq
 5fRnaRSaJZvJpAwOSIQ1FgZ+yzniuv+gipuajjqhJZznzoOu20oiHcaJfAJVIAoj1BsH Aw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3hjmfx9pvx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 26 Jul 2022 18:03:32 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 26QHExQn003129;
        Tue, 26 Jul 2022 18:03:32 GMT
Received: from ppma04wdc.us.ibm.com (1a.90.2fa9.ip4.static.sl-reverse.com [169.47.144.26])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3hjmfx9pv8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 26 Jul 2022 18:03:32 +0000
Received: from pps.filterd (ppma04wdc.us.ibm.com [127.0.0.1])
        by ppma04wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 26QHaXp5010173;
        Tue, 26 Jul 2022 18:03:31 GMT
Received: from b03cxnp07027.gho.boulder.ibm.com (b03cxnp07027.gho.boulder.ibm.com [9.17.130.14])
        by ppma04wdc.us.ibm.com with ESMTP id 3hg94am7eb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 26 Jul 2022 18:03:31 +0000
Received: from b03ledav001.gho.boulder.ibm.com (b03ledav001.gho.boulder.ibm.com [9.17.130.232])
        by b03cxnp07027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 26QI3Uoc38535572
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 26 Jul 2022 18:03:30 GMT
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4D51D6E054;
        Tue, 26 Jul 2022 18:03:30 +0000 (GMT)
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0FF536E052;
        Tue, 26 Jul 2022 18:03:28 +0000 (GMT)
Received: from farman-thinkpad-t470p (unknown [9.211.142.12])
        by b03ledav001.gho.boulder.ibm.com (Postfix) with ESMTP;
        Tue, 26 Jul 2022 18:03:28 +0000 (GMT)
Message-ID: <d23d6ef67bb709cbde3886ea24d528c3036bff9b.camel@linux.ibm.com>
Subject: Re: [RFC PATCH] vfio/ccw: Move mdev stuff out of struct subchannel
From:   Eric Farman <farman@linux.ibm.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     akrowiak@linux.ibm.com, alex.williamson@redhat.com,
        intel-gvt-dev@lists.freedesktop.org, jgg@nvidia.com,
        jjherne@linux.ibm.com, kvm@vger.kernel.org, kwankhede@nvidia.com,
        linux-s390@vger.kernel.org, mjrosato@linux.ibm.com,
        pasic@linux.ibm.com, vneethv@linux.ibm.com,
        zhenyuw@linux.intel.com, zhi.a.wang@intel.com
Date:   Tue, 26 Jul 2022 14:03:28 -0400
In-Reply-To: <20220726174817.GB14002@lst.de>
References: <20220720050629.GA6076@lst.de>
         <20220726153725.2573294-1-farman@linux.ibm.com>
         <20220726174817.GB14002@lst.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-18.el8) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: hlKyD_5yBzGTE-8AXCI9UIfOgJ7I2E8A
X-Proofpoint-ORIG-GUID: QnNDmIJl4isKDRb9DTYRVmPjsuwGe6d3
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-26_05,2022-07-26_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 spamscore=0
 mlxscore=0 phishscore=0 lowpriorityscore=0 mlxlogscore=459
 priorityscore=1501 impostorscore=0 malwarescore=0 bulkscore=0
 suspectscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2206140000 definitions=main-2207260069
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2022-07-26 at 19:48 +0200, Christoph Hellwig wrote:
> On Tue, Jul 26, 2022 at 05:37:25PM +0200, Eric Farman wrote:
> > Here's my swipe at a cleanup patch that can be folded in
> > to this series, to get the mdev stuff in a more proper
> > location for vfio-ccw.
> > 
> > As previously described, the subchannel is a device-agnostic
> > structure that does/should not need to know about specific
> > nuances such as mediated devices. This is why things like
> > struct vfio_ccw_private exist, so move these details there.
> 
> Should I resend the series with that folded in?  

That would be great. I'll give it another spin and can look over the
ccw changes without the smattering of fixups I have.

> At this point we're
> probably not talking about 5.20 anyway.

