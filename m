Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39249549B41
	for <lists+kvm@lfdr.de>; Mon, 13 Jun 2022 20:15:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244786AbiFMSPh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Jun 2022 14:15:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245066AbiFMSPG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Jun 2022 14:15:06 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CC182D1E7;
        Mon, 13 Jun 2022 07:10:15 -0700 (PDT)
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25DDahxw011975;
        Mon, 13 Jun 2022 14:10:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=QfLKbMb7cIw5v3tYJr7zvKgdZRe+cbXtG2HPvLS7uXA=;
 b=orOdpHcoYEetDFdNRR2goTxBPczi12XtuaxAYglXudznr7Y2CHaK6CjBHPkC4l+8KlUh
 SRhEPzQqtDelomIcgC0L7eBiu0/FpSCurSzznHq9TSAbRIZtHW9jctwU/yGib7FpAgU9
 0ktawcEgUORBdz+iQzarax/KVD7G8gmLTSF+hBZdg5Tpq3aCcIT1S9pe7MMETCsDFsek
 4FT1KAQWuT9wGP0baOJt5OVkSQ1GJ3P3sD3J54u+UqBt5NrInMTvvy7s5j8geBuLgj5e
 KVkCq/3bh1f2dhwzy8Cy+4Lttl4Q3EQ59a3pMyDAMkjc2GOIiohTxP4v5YM51lBNHObp 2A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3gp3jtm8ay-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 13 Jun 2022 14:10:06 +0000
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 25DCxPlj014688;
        Mon, 13 Jun 2022 14:10:06 GMT
Received: from ppma05wdc.us.ibm.com (1b.90.2fa9.ip4.static.sl-reverse.com [169.47.144.27])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3gp3jtm8ae-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 13 Jun 2022 14:10:06 +0000
Received: from pps.filterd (ppma05wdc.us.ibm.com [127.0.0.1])
        by ppma05wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 25DE6bxk012087;
        Mon, 13 Jun 2022 14:10:05 GMT
Received: from b01cxnp23032.gho.pok.ibm.com (b01cxnp23032.gho.pok.ibm.com [9.57.198.27])
        by ppma05wdc.us.ibm.com with ESMTP id 3gmjp9wt7s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 13 Jun 2022 14:10:05 +0000
Received: from b01ledav005.gho.pok.ibm.com (b01ledav005.gho.pok.ibm.com [9.57.199.110])
        by b01cxnp23032.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 25DEA4AP27132370
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 Jun 2022 14:10:04 GMT
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 72D1CAE05F;
        Mon, 13 Jun 2022 14:10:04 +0000 (GMT)
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BE785AE060;
        Mon, 13 Jun 2022 14:10:00 +0000 (GMT)
Received: from farman-thinkpad-t470p (unknown [9.211.62.157])
        by b01ledav005.gho.pok.ibm.com (Postfix) with ESMTP;
        Mon, 13 Jun 2022 14:10:00 +0000 (GMT)
Message-ID: <291fe7935b24273d9fdd9425a9ce02bb1f1d5448.camel@linux.ibm.com>
Subject: Re: [PATCH v1 14/18] vfio/mdev: Add mdev available instance
 checking to the core
From:   Eric Farman <farman@linux.ibm.com>
To:     Christoph Hellwig <hch@lst.de>,
        "Tian, Kevin" <kevin.tian@intel.com>
Cc:     Kirti Wankhede <kwankhede@nvidia.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>, Neo Jia <cjia@nvidia.com>,
        Dheeraj Nigam <dnigam@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>
Date:   Mon, 13 Jun 2022 10:08:29 -0400
In-Reply-To: <20220613064655.GA493@lst.de>
References: <20220602171948.2790690-1-farman@linux.ibm.com>
         <20220602171948.2790690-15-farman@linux.ibm.com>
         <63a87e1e-7d99-b091-4c6b-fa25dd7c5211@nvidia.com>
         <c818e1ef24c466a3b1d14d4ab10163d5e349a3b4.camel@linux.ibm.com>
         <BN9PR11MB5276228F26CC7B9EBE13489B8CA69@BN9PR11MB5276.namprd11.prod.outlook.com>
         <20220613064655.GA493@lst.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-18.el8) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 92wx5Go0EIdAsXRaqR1Re3qeer1xW2_s
X-Proofpoint-ORIG-GUID: 69G2lwM_-sgVqYGmHSSm_BmNJgrkptaC
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-13_06,2022-06-13_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0 mlxscore=0
 priorityscore=1501 bulkscore=0 adultscore=0 suspectscore=0 phishscore=0
 mlxlogscore=966 impostorscore=0 clxscore=1015 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2204290000
 definitions=main-2206130063
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2022-06-13 at 08:46 +0200, Christoph Hellwig wrote:
> On Fri, Jun 10, 2022 at 07:43:46AM +0000, Tian, Kevin wrote:
> > btw with those latest changes [1] we don't need .get_available()
> > then,
> > as mdev type is now added by mdev driver one-by-one then the
> > available instance can be provided directly in that path.
> 
> Yes, we can probably add a helper to add the vailable attibrute,
> which
> takes the number of instances.  Is it ok if I just add a version of
> this
> patch and the device_api one to my series, and we rebase this series
> on top of it?  I'll try to get out a new version ASAP.

That's fine with me. Thanks!

Eric


