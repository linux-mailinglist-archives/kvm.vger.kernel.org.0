Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 809F16CD9D3
	for <lists+kvm@lfdr.de>; Wed, 29 Mar 2023 15:00:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229988AbjC2NAu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Mar 2023 09:00:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229552AbjC2NAt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Mar 2023 09:00:49 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3ECD19B3;
        Wed, 29 Mar 2023 06:00:46 -0700 (PDT)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32TCCC2Y001856;
        Wed, 29 Mar 2023 13:00:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=bA1MUwckwvQRSi6YLVXqNA0+vzkfU5E0f9ErJlpnmQ0=;
 b=HGhsFIK/2fsFmCe08N7mHdJr8G9hBOgAlObDylvrVWe7/nKc2V/BAD8EbjusxrsTmeim
 hDauVrcE0WvufkA5KqPexR+n5eAtHP1OVQJdLOCdT7BWgHpeUNpY/wBv6HUZmARzg+AR
 vTVU/4KDuO/NwJYxOt/Tbd0wcgDlfWe29TGylwJLheTqWSEImySAx/byKrYr7GmyBlfG
 1eRAyjLLsHZ1I5jFoqHvC7Md2mYsaobJUGlHErRyFUtaPru0g2U07uGHMh0q4F301oQb
 EgwuFLagB8dPONdD5RTtVguig9e1pFFs+oCw+ODnTM39SP7yavLuNsUlursA56E4oTRh Bg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pmn4m1ban-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 29 Mar 2023 13:00:46 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 32TCCimr003289;
        Wed, 29 Mar 2023 13:00:45 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pmn4m1b9c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 29 Mar 2023 13:00:45 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 32SMoZDu009365;
        Wed, 29 Mar 2023 13:00:43 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
        by ppma04ams.nl.ibm.com (PPS) with ESMTPS id 3phrk6mys9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 29 Mar 2023 13:00:43 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
        by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 32TD0ZiB25756282
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 29 Mar 2023 13:00:35 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0499820043;
        Wed, 29 Mar 2023 13:00:35 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 91F1E2004F;
        Wed, 29 Mar 2023 13:00:34 +0000 (GMT)
Received: from p-imbrenda (unknown [9.171.75.123])
        by smtpav02.fra02v.mail.ibm.com (Postfix) with SMTP;
        Wed, 29 Mar 2023 13:00:34 +0000 (GMT)
Date:   Wed, 29 Mar 2023 15:00:32 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Nico Boehr <nrb@linux.ibm.com>
Cc:     Janosch Frank <frankja@linux.ibm.com>, thuth@redhat.com,
        kvm@vger.kernel.org, linux-s390@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH v1 1/4] s390x: sie: switch to home space
 mode before entering SIE
Message-ID: <20230329150032.7093e25b@p-imbrenda>
In-Reply-To: <168009425098.295696.4253423899606982653@t14-nrb>
References: <20230327082118.2177-1-nrb@linux.ibm.com>
        <20230327082118.2177-2-nrb@linux.ibm.com>
        <afcf5186-c3f2-d777-be5f-408318039f2d@linux.ibm.com>
        <168009425098.295696.4253423899606982653@t14-nrb>
Organization: IBM
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: My8klWk_16GAmFpcvd9DCmLi9V3hAvQ_
X-Proofpoint-ORIG-GUID: UPNQsptd9dOYWA1O9Jaz8u9oJvG_P9fZ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-29_06,2023-03-28_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 mlxlogscore=999 priorityscore=1501 suspectscore=0 adultscore=0
 clxscore=1015 impostorscore=0 mlxscore=0 lowpriorityscore=0 phishscore=0
 spamscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2303290102
X-Spam-Status: No, score=-0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 29 Mar 2023 14:50:50 +0200
Nico Boehr <nrb@linux.ibm.com> wrote:

> Quoting Janosch Frank (2023-03-28 16:13:04)
> > On 3/27/23 10:21, Nico Boehr wrote:  
> > > This is to prepare for running guests without MSO/MSL, which is
> > > currently not possible.
> > > 
> > > We already have code in sie64a to setup a guest primary ASCE before
> > > entering SIE, so we can in theory switch to the page tables which
> > > translate gpa to hpa.
> > > 
> > > But the host is running in primary space mode already, so changing the
> > > primary ASCE before entering SIE will also affect the host's code and
> > > data.
> > > 
> > > To make this switch useful, the host should run in a different address
> > > space mode. Hence, set up and change to home address space mode before
> > > installing the guest ASCE.
> > > 
> > > The home space ASCE is just copied over from the primary space ASCE, so
> > > no functional change is intended, also for tests that want to use
> > > MSO/MSL. If a test intends to use a different primary space ASCE, it can
> > > now just set the guest.asce in the save_area.
> > >   
> > [...]  
> > > +     /* set up home address space to match primary space */
> > > +     old_cr13 = stctg(13);
> > > +     lctlg(13, stctg(1));
> > > +
> > > +     /* switch to home space so guest tables can be different from host */
> > > +     psw_mask_set_bits(PSW_MASK_HOME);
> > > +
> > > +     /* also handle all interruptions in home space while in SIE */
> > > +     lowcore.pgm_new_psw.mask |= PSW_MASK_DAT_HOME;  
> >   
> > > +     lowcore.ext_new_psw.mask |= PSW_MASK_DAT_HOME;
> > > +     lowcore.io_new_psw.mask |= PSW_MASK_DAT_HOME;  
> > We didn't enable DAT in these two cases as far as I can see so this is 
> > superfluous or we should change the mmu code. Also it's missing the svc 
> > and machine check.  
> 
> Right. Is there a particular reason why we only run DAT on for PGM ints?

a fixup handler for PGM it might need to run with DAT on (e.g. to
access data that is not identity mapped), whereas for other interrupts
it's not needed (at least not yet ;) )

> 
> > The whole bit manipulation thing looks a bit crude. It might make more 
> > sense to drop into real mode for a few instructions and have a dedicated 
> > storage location for an extended PSW mask and an interrupt ASCE as part 
> > of the interrupt call code instead.
> > 
> > Opinions?  
> 
> Maybe I don't get it, but I personally don't quite see the advantage. It seems
> to me this would make things much more complicated just to avoid a few simple
> bitops.
> 
> It maybe also depends on how many new_psws we have to touch. If it's really just
> the PGM, the current solution seems simple enough.
> 
> But if others also prefer Janosch's suggestion, I am happy to implement it.

