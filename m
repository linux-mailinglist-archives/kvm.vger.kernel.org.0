Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 505C42753AF
	for <lists+kvm@lfdr.de>; Wed, 23 Sep 2020 10:51:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726413AbgIWIvy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Sep 2020 04:51:54 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:59250 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726130AbgIWIvx (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 23 Sep 2020 04:51:53 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08N8WW9M145621;
        Wed, 23 Sep 2020 04:51:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=2XXRDnFO/61UBTTV4Z8JpRj9BrTLJ0R2VP3pc0tFfPI=;
 b=sNMx1ruptdj/TwZ10RigDrrUPiRBSEmrScUoRpdq8pBtZyMKqU5cuMCI359HywyNZrtp
 QwMnDn1loieWc1+tOfIfK5Vv4SHDIUPmRZFoI9WJkJzo3FkMGUIJXYUxsFdT526Xf1Q+
 G4rit3F1vT0qp32Oz8IVnFonJv6nw2enKRk8S16uKLN9Avr1Fe4MHxi5NsC69E71uEIT
 memXtqaz5dUThNQcFPlsd1S8QOZUTZm0x0RY+XgV6x4jmaWjoIvTwegqxwZvlzsr/Ttg
 +nUpwP5OdaUo/XRDkaE0opWwzGm7etFlbUhpI4yIfAb8TmrtoAw174Kd2D9ICkwP4QM8 zg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 33r164c1en-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Sep 2020 04:51:42 -0400
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 08N8XgL9150134;
        Wed, 23 Sep 2020 04:51:42 -0400
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0b-001b2d01.pphosted.com with ESMTP id 33r164c1dt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Sep 2020 04:51:42 -0400
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 08N8lNlI021274;
        Wed, 23 Sep 2020 08:51:40 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma06fra.de.ibm.com with ESMTP id 33n98gt2gr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Sep 2020 08:51:40 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 08N8o2O833751458
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 23 Sep 2020 08:50:02 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9225A4204B;
        Wed, 23 Sep 2020 08:51:37 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DAC4942041;
        Wed, 23 Sep 2020 08:51:36 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.32.68])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 23 Sep 2020 08:51:36 +0000 (GMT)
Subject: Re: [PATCH v5 3/3] vfio/pci: Decouple PCI_COMMAND_MEMORY bit checks
 from is_virtfn
To:     Alex Williamson <alex.williamson@redhat.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>
Cc:     bhelgaas@google.com, schnelle@linux.ibm.com, mpe@ellerman.id.au,
        oohall@gmail.com, cohuck@redhat.com, kevin.tian@intel.com,
        hca@linux.ibm.com, gor@linux.ibm.com, borntraeger@de.ibm.com,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, linux-pci@vger.kernel.org
References: <1599749997-30489-1-git-send-email-mjrosato@linux.ibm.com>
 <1599749997-30489-4-git-send-email-mjrosato@linux.ibm.com>
 <08afc6b2-7549-5440-a947-af0b598288c2@linux.ibm.com>
 <20200922104030.07e0dfd9@x1.home>
From:   Pierre Morel <pmorel@linux.ibm.com>
Message-ID: <f11cfdd7-c743-b26d-2843-0cb74ef2643e@linux.ibm.com>
Date:   Wed, 23 Sep 2020 10:51:36 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200922104030.07e0dfd9@x1.home>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-23_03:2020-09-23,2020-09-23 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 adultscore=0 impostorscore=0 mlxlogscore=999 malwarescore=0 spamscore=0
 phishscore=0 suspectscore=0 mlxscore=0 clxscore=1011 bulkscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009230064
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2020-09-22 18:40, Alex Williamson wrote:
> On Mon, 21 Sep 2020 08:43:29 -0400
> Matthew Rosato <mjrosato@linux.ibm.com> wrote:
> 
>> On 9/10/20 10:59 AM, Matthew Rosato wrote:
>>> While it is true that devices with is_virtfn=1 will have a Memory Space
>>> Enable bit that is hard-wired to 0, this is not the only case where we
>>> see this behavior -- For example some bare-metal hypervisors lack
>>> Memory Space Enable bit emulation for devices not setting is_virtfn
>>> (s390). Fix this by instead checking for the newly-added
>>> no_command_memory bit which directly denotes the need for
>>> PCI_COMMAND_MEMORY emulation in vfio.
>>>
>>> Fixes: abafbc551fdd ("vfio-pci: Invalidate mmaps and block MMIO access on disabled memory")
>>> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
>>> Reviewed-by: Niklas Schnelle <schnelle@linux.ibm.com>
>>> Reviewed-by: Pierre Morel <pmorel@linux.ibm.com>
>>
>> Polite ping on this patch as the other 2 have now received maintainer
>> ACKs or reviews.  I'm concerned about this popping up in distros as
>> abafbc551fdd was a CVE fix.  Related, see question from the cover:
>>
>> - Restored the fixes tag to patch 3 (but the other 2 patches are
>>     now pre-reqs -- cc stable 5.8?)
> 
> I've got these queued in my local branch which I'll push to next for
> v5.10.  I'm thinking that perhaps the right thing would be to add the
> fixes tag to all three patches, otherwise I could see that the PCI/VF
> change might get picked as a dependency, but not the s390 specific one.
> Does this sound correct to everyone?  Thanks,
> 
> Alex
> 
sound correct for me.
Thanks.

Pierre

-- 
Pierre Morel
IBM Lab Boeblingen
