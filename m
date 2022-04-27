Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 456EC511A7A
	for <lists+kvm@lfdr.de>; Wed, 27 Apr 2022 16:56:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235945AbiD0N3a (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Apr 2022 09:29:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235863AbiD0N3Z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Apr 2022 09:29:25 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C31663B3E0;
        Wed, 27 Apr 2022 06:26:13 -0700 (PDT)
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23RCidEh010459;
        Wed, 27 Apr 2022 13:26:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=0MMC0/ng/dIdP/pAZ7koQhzGXGZhfRB8Wma3oTWB3nw=;
 b=bfSYnoxx3Yp/2pqHFSvUHpQSPVymtndE5UDPH7UEY2FBbsvq9p0wYXqyPb+3+fpAu6L6
 evkzrH3Dp05Yg3swdIFNshryG64wRK4egCms+o7olkdcjJy3OlrT6ClGaUFcsRqXDF6z
 Q6qovf3CYB9A3I/rffphgfi9d3uXYX701TIAgnph0/0t/DEl4VBR6zq5LOONqadqK7i8
 t0i5hZyS9PIB93YnIqhkkPDx5E+CrMYWH+cId9twejxsWm7rB1ItFNFFuAQb90XxPZUI
 B7Q86gpOqFmV89zeoeDLWx/Q/NRwgHerG4Dt9rYKJe8w5moKzEOQ6lGTDv9S9Pdzlxmf NQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3fpv88bn50-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 27 Apr 2022 13:26:07 +0000
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 23RCjXQq013232;
        Wed, 27 Apr 2022 13:26:07 GMT
Received: from ppma05wdc.us.ibm.com (1b.90.2fa9.ip4.static.sl-reverse.com [169.47.144.27])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3fpv88bn4n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 27 Apr 2022 13:26:06 +0000
Received: from pps.filterd (ppma05wdc.us.ibm.com [127.0.0.1])
        by ppma05wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 23RDCrgk032328;
        Wed, 27 Apr 2022 13:26:06 GMT
Received: from b01cxnp23034.gho.pok.ibm.com (b01cxnp23034.gho.pok.ibm.com [9.57.198.29])
        by ppma05wdc.us.ibm.com with ESMTP id 3fm939mb7b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 27 Apr 2022 13:26:06 +0000
Received: from b01ledav006.gho.pok.ibm.com (b01ledav006.gho.pok.ibm.com [9.57.199.111])
        by b01cxnp23034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 23RDQ5B124576272
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 Apr 2022 13:26:05 GMT
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7602CAC05E;
        Wed, 27 Apr 2022 13:26:05 +0000 (GMT)
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6F520AC062;
        Wed, 27 Apr 2022 13:26:00 +0000 (GMT)
Received: from [9.211.73.42] (unknown [9.211.73.42])
        by b01ledav006.gho.pok.ibm.com (Postfix) with ESMTP;
        Wed, 27 Apr 2022 13:26:00 +0000 (GMT)
Message-ID: <6a4db1a9-70c4-3ed1-b055-c5161d021d3d@linux.ibm.com>
Date:   Wed, 27 Apr 2022 09:25:59 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH v6 10/21] KVM: s390: pci: add basic kvm_zdev structure
Content-Language: en-US
To:     kernel test robot <lkp@intel.com>, linux-s390@vger.kernel.org
Cc:     kbuild-all@lists.01.org, alex.williamson@redhat.com,
        cohuck@redhat.com, schnelle@linux.ibm.com, farman@linux.ibm.com,
        pmorel@linux.ibm.com, borntraeger@linux.ibm.com, hca@linux.ibm.com,
        gor@linux.ibm.com, gerald.schaefer@linux.ibm.com,
        agordeev@linux.ibm.com, svens@linux.ibm.com, frankja@linux.ibm.com,
        david@redhat.com, imbrenda@linux.ibm.com, vneethv@linux.ibm.com,
        oberpar@linux.ibm.com, freude@linux.ibm.com, thuth@redhat.com,
        pasic@linux.ibm.com, pbonzini@redhat.com, corbet@lwn.net,
        jgg@nvidia.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org
References: <20220426200842.98655-11-mjrosato@linux.ibm.com>
 <202204271653.1ZoYsV9W-lkp@intel.com>
From:   Matthew Rosato <mjrosato@linux.ibm.com>
In-Reply-To: <202204271653.1ZoYsV9W-lkp@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Fwjb9CrrNEutd_u3c5vwxtKiNp0v1T8S
X-Proofpoint-ORIG-GUID: x1gbDLIaaprs5nhPa-x4HY2M5HAAiOS7
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-27_04,2022-04-27_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 lowpriorityscore=0 malwarescore=0 clxscore=1011 priorityscore=1501
 phishscore=0 adultscore=0 suspectscore=0 spamscore=0 bulkscore=0
 mlxlogscore=773 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204270086
X-Spam-Status: No, score=-3.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/27/22 4:41 AM, kernel test robot wrote:
> Hi Matthew,
> 
> I love your patch! Perhaps something to improve:
> 
> [auto build test WARNING on v5.18-rc4]
> [cannot apply to s390/features kvms390/next awilliam-vfio/next next-20220427]
> [If your patch is applied to the wrong git tree, kindly drop us a note.
> And when submitting patch, we suggest to use '--base' as documented in
> https://git-scm.com/docs/git-format-patch]
> 
> url:    https://github.com/intel-lab-lkp/linux/commits/Matthew-Rosato/KVM-s390-enable-zPCI-for-interpretive-execution/20220427-041853
> base:    af2d861d4cd2a4da5137f795ee3509e6f944a25b
> config: s390-defconfig (https://download.01.org/0day-ci/archive/20220427/202204271653.1ZoYsV9W-lkp@intel.com/config)
> compiler: s390-linux-gcc (GCC) 11.3.0
> reproduce (this is a W=1 build):
>          wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>          chmod +x ~/bin/make.cross
>          # https://github.com/intel-lab-lkp/linux/commit/e6d8c620090a7b184afdf5b5123d10ac45776eaf
>          git remote add linux-review https://github.com/intel-lab-lkp/linux
>          git fetch --no-tags linux-review Matthew-Rosato/KVM-s390-enable-zPCI-for-interpretive-execution/20220427-041853
>          git checkout e6d8c620090a7b184afdf5b5123d10ac45776eaf
>          # save the config file
>          mkdir build_dir && cp config build_dir/.config
>          COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.3.0 make.cross W=1 O=build_dir ARCH=s390 SHELL=/bin/bash arch/s390/kvm/
> 
> If you fix the issue, kindly add following tag as appropriate
> Reported-by: kernel test robot <lkp@intel.com>
> 
> All warnings (new ones prefixed by >>):
> 
>>> arch/s390/kvm/pci.c:14:5: warning: no previous prototype for 'kvm_s390_pci_dev_open' [-Wmissing-prototypes]
>        14 | int kvm_s390_pci_dev_open(struct zpci_dev *zdev)
>           |     ^~~~~~~~~~~~~~~~~~~~~
>>> arch/s390/kvm/pci.c:29:6: warning: no previous prototype for 'kvm_s390_pci_dev_release' [-Wmissing-prototypes]
>        29 | void kvm_s390_pci_dev_release(struct zpci_dev *zdev)
>           |      ^~~~~~~~~~~~~~~~~~~~~~~~
> 

Oops, these 2 functions no longer need to be externalized and can simply 
be marked static.

> 
> vim +/kvm_s390_pci_dev_open +14 arch/s390/kvm/pci.c
> 
>      13	
>    > 14	int kvm_s390_pci_dev_open(struct zpci_dev *zdev)
>      15	{
>      16		struct kvm_zdev *kzdev;
>      17	
>      18		kzdev = kzalloc(sizeof(struct kvm_zdev), GFP_KERNEL);
>      19		if (!kzdev)
>      20			return -ENOMEM;
>      21	
>      22		kzdev->zdev = zdev;
>      23		zdev->kzdev = kzdev;
>      24	
>      25		return 0;
>      26	}
>      27	EXPORT_SYMBOL_GPL(kvm_s390_pci_dev_open);
>      28	
>    > 29	void kvm_s390_pci_dev_release(struct zpci_dev *zdev)
> 

