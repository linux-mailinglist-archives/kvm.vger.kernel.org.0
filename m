Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2EA1A757EEB
	for <lists+kvm@lfdr.de>; Tue, 18 Jul 2023 16:04:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232939AbjGROD5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jul 2023 10:03:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233234AbjGROCw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Jul 2023 10:02:52 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B614C1712;
        Tue, 18 Jul 2023 07:02:06 -0700 (PDT)
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36IDdlaQ031613;
        Tue, 18 Jul 2023 13:58:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 subject : to : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=S+/+EWduJibm4taM1UCZJc7AYGUWSxbltsJpEmiFteA=;
 b=RMw/fVWkLvDia/+ld2AJPOfTvPEeHK26D9PvC+JuZhAV5zpXefqBfuzQ+mcZe1odeMZp
 uc2ud3nmiWA8NEHMFHR7ZV22U+gQW9U0GCxkH44a+4ke6j8YJBmX9vZ1xU0F2cZ3MnK/
 oNr6nq8NAFEBsS725Q9tGFn2fYlKfdOrM1yFBNUWJYXTfWyAERTSrVB/t6B+15qxVmbH
 Mja2SV/RWISjNIZbuJ6cLM0ze6BkZHqnuMaqrv09DZvEMC9NGNXT8k2aa0cWsX6+mCL/
 NbWY7S7STGpZFqj4GqWf8Z8bCqqB92aAiKu3vQnTuDcyw2I8PnDRSJufdnNCP/coFTj4 kQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rwutn0jnc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Jul 2023 13:58:54 +0000
Received: from m0356516.ppops.net (m0356516.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 36IDeL1T032713;
        Tue, 18 Jul 2023 13:58:53 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rwutn0jn0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Jul 2023 13:58:53 +0000
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
        by ppma12.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 36I6Pq8R017218;
        Tue, 18 Jul 2023 13:58:52 GMT
Received: from smtprelay05.dal12v.mail.ibm.com ([172.16.1.7])
        by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 3rv5srp3kj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Jul 2023 13:58:52 +0000
Received: from smtpav05.wdc07v.mail.ibm.com (smtpav05.wdc07v.mail.ibm.com [10.39.53.232])
        by smtprelay05.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 36IDwpL064815384
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Jul 2023 13:58:51 GMT
Received: from smtpav05.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 434E558061;
        Tue, 18 Jul 2023 13:58:51 +0000 (GMT)
Received: from smtpav05.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D77675805F;
        Tue, 18 Jul 2023 13:58:47 +0000 (GMT)
Received: from [9.61.0.228] (unknown [9.61.0.228])
        by smtpav05.wdc07v.mail.ibm.com (Postfix) with ESMTP;
        Tue, 18 Jul 2023 13:58:47 +0000 (GMT)
Message-ID: <e59eafd4-90cb-958f-ce31-d4658e8cdde4@linux.ibm.com>
Date:   Tue, 18 Jul 2023 09:58:47 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH] docs: move s390 under arch
To:     Costa Shulyupin <costa.shul@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Niklas Schnelle <schnelle@linux.ibm.com>,
        Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>,
        Kim Phillips <kim.phillips@amd.com>,
        Yantengsi <siyanteng@loongson.cn>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Vineet Gupta <vgupta@kernel.org>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Alex Williamson <alex.williamson@redhat.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Mikhail Zaslonko <zaslonko@linux.ibm.com>,
        Eric DeVolder <eric.devolder@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:S390 ARCHITECTURE" <linux-s390@vger.kernel.org>,
        "open list:S390 VFIO-CCW DRIVER" <kvm@vger.kernel.org>
References: <20230718045550.495428-1-costa.shul@redhat.com>
Content-Language: en-US
From:   Anthony Krowiak <akrowiak@linux.ibm.com>
In-Reply-To: <20230718045550.495428-1-costa.shul@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: mVgaRJV7AkeBIZUPgZbB8pBMe_C37WOe
X-Proofpoint-ORIG-GUID: bE6VXwX5UOcJVymHfb12oOILadcLMRYG
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-18_10,2023-07-18_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 phishscore=0
 mlxlogscore=999 suspectscore=0 spamscore=0 lowpriorityscore=0 adultscore=0
 priorityscore=1501 clxscore=1011 mlxscore=0 impostorscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2306200000
 definitions=main-2307180124
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

for arch/s390/vfio-ap*
Reviewed-by: Tony Krowiak <akrowiak@linux.ibm.com>

On 7/18/23 12:55 AM, Costa Shulyupin wrote:
> and fix all in-tree references.
> 
> Architecture-specific documentation is being moved into Documentation/arch/
> as a way of cleaning up the top-level documentation directory and making
> the docs hierarchy more closely match the source hierarchy.
> 
> Signed-off-by: Costa Shulyupin <costa.shul@redhat.com>
> ---
>   Documentation/admin-guide/kernel-parameters.txt   | 4 ++--
>   Documentation/arch/index.rst                      | 2 +-
>   Documentation/{ => arch}/s390/3270.ChangeLog      | 0
>   Documentation/{ => arch}/s390/3270.rst            | 4 ++--
>   Documentation/{ => arch}/s390/cds.rst             | 2 +-
>   Documentation/{ => arch}/s390/common_io.rst       | 2 +-
>   Documentation/{ => arch}/s390/config3270.sh       | 0
>   Documentation/{ => arch}/s390/driver-model.rst    | 0
>   Documentation/{ => arch}/s390/features.rst        | 0
>   Documentation/{ => arch}/s390/index.rst           | 0
>   Documentation/{ => arch}/s390/monreader.rst       | 0
>   Documentation/{ => arch}/s390/pci.rst             | 2 +-
>   Documentation/{ => arch}/s390/qeth.rst            | 0
>   Documentation/{ => arch}/s390/s390dbf.rst         | 0
>   Documentation/{ => arch}/s390/text_files.rst      | 0
>   Documentation/{ => arch}/s390/vfio-ap-locking.rst | 0
>   Documentation/{ => arch}/s390/vfio-ap.rst         | 0
>   Documentation/{ => arch}/s390/vfio-ccw.rst        | 2 +-
>   Documentation/{ => arch}/s390/zfcpdump.rst        | 0
>   Documentation/driver-api/s390-drivers.rst         | 4 ++--
>   MAINTAINERS                                       | 8 ++++----
>   arch/s390/Kconfig                                 | 4 ++--
>   arch/s390/include/asm/debug.h                     | 4 ++--
>   drivers/s390/char/zcore.c                         | 2 +-
>   kernel/Kconfig.kexec                              | 2 +-
>   25 files changed, 21 insertions(+), 21 deletions(-)
>   rename Documentation/{ => arch}/s390/3270.ChangeLog (100%)
>   rename Documentation/{ => arch}/s390/3270.rst (99%)
>   rename Documentation/{ => arch}/s390/cds.rst (99%)
>   rename Documentation/{ => arch}/s390/common_io.rst (98%)
>   rename Documentation/{ => arch}/s390/config3270.sh (100%)
>   rename Documentation/{ => arch}/s390/driver-model.rst (100%)
>   rename Documentation/{ => arch}/s390/features.rst (100%)
>   rename Documentation/{ => arch}/s390/index.rst (100%)
>   rename Documentation/{ => arch}/s390/monreader.rst (100%)
>   rename Documentation/{ => arch}/s390/pci.rst (99%)
>   rename Documentation/{ => arch}/s390/qeth.rst (100%)
>   rename Documentation/{ => arch}/s390/s390dbf.rst (100%)
>   rename Documentation/{ => arch}/s390/text_files.rst (100%)
>   rename Documentation/{ => arch}/s390/vfio-ap-locking.rst (100%)
>   rename Documentation/{ => arch}/s390/vfio-ap.rst (100%)
>   rename Documentation/{ => arch}/s390/vfio-ccw.rst (99%)
>   rename Documentation/{ => arch}/s390/zfcpdump.rst (100%)
> 
> diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
> index a921507e7c32..aa8389262e31 100644
> --- a/Documentation/admin-guide/kernel-parameters.txt
> +++ b/Documentation/admin-guide/kernel-parameters.txt
> @@ -553,7 +553,7 @@
>   			others).
>   
>   	ccw_timeout_log	[S390]
> -			See Documentation/s390/common_io.rst for details.
> +			See Documentation/arch/s390/common_io.rst for details.
>   
>   	cgroup_disable=	[KNL] Disable a particular controller or optional feature
>   			Format: {name of the controller(s) or feature(s) to disable}
> @@ -598,7 +598,7 @@
>   			Setting checkreqprot to 1 is deprecated.
>   
>   	cio_ignore=	[S390]
> -			See Documentation/s390/common_io.rst for details.
> +			See Documentation/arch/s390/common_io.rst for details.
>   
>   	clearcpuid=X[,X...] [X86]
>   			Disable CPUID feature X for the kernel. See
> diff --git a/Documentation/arch/index.rst b/Documentation/arch/index.rst
> index 4b6b1beebad6..d39504fae12c 100644
> --- a/Documentation/arch/index.rst
> +++ b/Documentation/arch/index.rst
> @@ -21,7 +21,7 @@ implementation.
>      parisc/index
>      ../powerpc/index
>      ../riscv/index
> -   ../s390/index
> +   s390/index
>      sh/index
>      sparc/index
>      x86/index
> diff --git a/Documentation/s390/3270.ChangeLog b/Documentation/arch/s390/3270.ChangeLog
> similarity index 100%
> rename from Documentation/s390/3270.ChangeLog
> rename to Documentation/arch/s390/3270.ChangeLog
> diff --git a/Documentation/s390/3270.rst b/Documentation/arch/s390/3270.rst
> similarity index 99%
> rename from Documentation/s390/3270.rst
> rename to Documentation/arch/s390/3270.rst
> index e09e77954238..467eace91473 100644
> --- a/Documentation/s390/3270.rst
> +++ b/Documentation/arch/s390/3270.rst
> @@ -116,7 +116,7 @@ Here are the installation steps in detail:
>   	as a 3270, not a 3215.
>   
>   	5. Run the 3270 configuration script config3270.  It is
> -	distributed in this same directory, Documentation/s390, as
> +	distributed in this same directory, Documentation/arch/s390, as
>   	config3270.sh.  Inspect the output script it produces,
>   	/tmp/mkdev3270, and then run that script.  This will create the
>   	necessary character special device files and make the necessary
> @@ -125,7 +125,7 @@ Here are the installation steps in detail:
>   	Then notify /sbin/init that /etc/inittab has changed, by issuing
>   	the telinit command with the q operand::
>   
> -		cd Documentation/s390
> +		cd Documentation/arch/s390
>   		sh config3270.sh
>   		sh /tmp/mkdev3270
>   		telinit q
> diff --git a/Documentation/s390/cds.rst b/Documentation/arch/s390/cds.rst
> similarity index 99%
> rename from Documentation/s390/cds.rst
> rename to Documentation/arch/s390/cds.rst
> index 7006d8209d2e..bcad2a14244a 100644
> --- a/Documentation/s390/cds.rst
> +++ b/Documentation/arch/s390/cds.rst
> @@ -39,7 +39,7 @@ some of them are ESA/390 platform specific.
>   
>   Note:
>     In order to write a driver for S/390, you also need to look into the interface
> -  described in Documentation/s390/driver-model.rst.
> +  described in Documentation/arch/s390/driver-model.rst.
>   
>   Note for porting drivers from 2.4:
>   
> diff --git a/Documentation/s390/common_io.rst b/Documentation/arch/s390/common_io.rst
> similarity index 98%
> rename from Documentation/s390/common_io.rst
> rename to Documentation/arch/s390/common_io.rst
> index 846485681ce7..6dcb40cb7145 100644
> --- a/Documentation/s390/common_io.rst
> +++ b/Documentation/arch/s390/common_io.rst
> @@ -136,5 +136,5 @@ debugfs entries
>   
>     The level of logging can be changed to be more or less verbose by piping to
>     /sys/kernel/debug/s390dbf/cio_*/level a number between 0 and 6; see the
> -  documentation on the S/390 debug feature (Documentation/s390/s390dbf.rst)
> +  documentation on the S/390 debug feature (Documentation/arch/s390/s390dbf.rst)
>     for details.
> diff --git a/Documentation/s390/config3270.sh b/Documentation/arch/s390/config3270.sh
> similarity index 100%
> rename from Documentation/s390/config3270.sh
> rename to Documentation/arch/s390/config3270.sh
> diff --git a/Documentation/s390/driver-model.rst b/Documentation/arch/s390/driver-model.rst
> similarity index 100%
> rename from Documentation/s390/driver-model.rst
> rename to Documentation/arch/s390/driver-model.rst
> diff --git a/Documentation/s390/features.rst b/Documentation/arch/s390/features.rst
> similarity index 100%
> rename from Documentation/s390/features.rst
> rename to Documentation/arch/s390/features.rst
> diff --git a/Documentation/s390/index.rst b/Documentation/arch/s390/index.rst
> similarity index 100%
> rename from Documentation/s390/index.rst
> rename to Documentation/arch/s390/index.rst
> diff --git a/Documentation/s390/monreader.rst b/Documentation/arch/s390/monreader.rst
> similarity index 100%
> rename from Documentation/s390/monreader.rst
> rename to Documentation/arch/s390/monreader.rst
> diff --git a/Documentation/s390/pci.rst b/Documentation/arch/s390/pci.rst
> similarity index 99%
> rename from Documentation/s390/pci.rst
> rename to Documentation/arch/s390/pci.rst
> index a1a72a47dc96..d5755484d8e7 100644
> --- a/Documentation/s390/pci.rst
> +++ b/Documentation/arch/s390/pci.rst
> @@ -40,7 +40,7 @@ For example:
>     Change the level of logging to be more or less verbose by piping
>     a number between 0 and 6 to  /sys/kernel/debug/s390dbf/pci_*/level. For
>     details, see the documentation on the S/390 debug feature at
> -  Documentation/s390/s390dbf.rst.
> +  Documentation/arch/s390/s390dbf.rst.
>   
>   Sysfs entries
>   =============
> diff --git a/Documentation/s390/qeth.rst b/Documentation/arch/s390/qeth.rst
> similarity index 100%
> rename from Documentation/s390/qeth.rst
> rename to Documentation/arch/s390/qeth.rst
> diff --git a/Documentation/s390/s390dbf.rst b/Documentation/arch/s390/s390dbf.rst
> similarity index 100%
> rename from Documentation/s390/s390dbf.rst
> rename to Documentation/arch/s390/s390dbf.rst
> diff --git a/Documentation/s390/text_files.rst b/Documentation/arch/s390/text_files.rst
> similarity index 100%
> rename from Documentation/s390/text_files.rst
> rename to Documentation/arch/s390/text_files.rst
> diff --git a/Documentation/s390/vfio-ap-locking.rst b/Documentation/arch/s390/vfio-ap-locking.rst
> similarity index 100%
> rename from Documentation/s390/vfio-ap-locking.rst
> rename to Documentation/arch/s390/vfio-ap-locking.rst
> diff --git a/Documentation/s390/vfio-ap.rst b/Documentation/arch/s390/vfio-ap.rst
> similarity index 100%
> rename from Documentation/s390/vfio-ap.rst
> rename to Documentation/arch/s390/vfio-ap.rst
> diff --git a/Documentation/s390/vfio-ccw.rst b/Documentation/arch/s390/vfio-ccw.rst
> similarity index 99%
> rename from Documentation/s390/vfio-ccw.rst
> rename to Documentation/arch/s390/vfio-ccw.rst
> index 37026fa18179..42960b7b0d70 100644
> --- a/Documentation/s390/vfio-ccw.rst
> +++ b/Documentation/arch/s390/vfio-ccw.rst
> @@ -440,6 +440,6 @@ Reference
>   1. ESA/s390 Principles of Operation manual (IBM Form. No. SA22-7832)
>   2. ESA/390 Common I/O Device Commands manual (IBM Form. No. SA22-7204)
>   3. https://en.wikipedia.org/wiki/Channel_I/O
> -4. Documentation/s390/cds.rst
> +4. Documentation/arch/s390/cds.rst
>   5. Documentation/driver-api/vfio.rst
>   6. Documentation/driver-api/vfio-mediated-device.rst
> diff --git a/Documentation/s390/zfcpdump.rst b/Documentation/arch/s390/zfcpdump.rst
> similarity index 100%
> rename from Documentation/s390/zfcpdump.rst
> rename to Documentation/arch/s390/zfcpdump.rst
> diff --git a/Documentation/driver-api/s390-drivers.rst b/Documentation/driver-api/s390-drivers.rst
> index 5158577bc29b..8c0845c4eee7 100644
> --- a/Documentation/driver-api/s390-drivers.rst
> +++ b/Documentation/driver-api/s390-drivers.rst
> @@ -27,7 +27,7 @@ not strictly considered I/O devices. They are considered here as well,
>   although they are not the focus of this document.
>   
>   Some additional information can also be found in the kernel source under
> -Documentation/s390/driver-model.rst.
> +Documentation/arch/s390/driver-model.rst.
>   
>   The css bus
>   ===========
> @@ -38,7 +38,7 @@ into several categories:
>   * Standard I/O subchannels, for use by the system. They have a child
>     device on the ccw bus and are described below.
>   * I/O subchannels bound to the vfio-ccw driver. See
> -  Documentation/s390/vfio-ccw.rst.
> +  Documentation/arch/s390/vfio-ccw.rst.
>   * Message subchannels. No Linux driver currently exists.
>   * CHSC subchannels (at most one). The chsc subchannel driver can be used
>     to send asynchronous chsc commands.
> diff --git a/MAINTAINERS b/MAINTAINERS
> index b68512f1b65f..2649dffe9f46 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -18642,7 +18642,7 @@ L:	linux-s390@vger.kernel.org
>   S:	Supported
>   T:	git git://git.kernel.org/pub/scm/linux/kernel/git/s390/linux.git
>   F:	Documentation/driver-api/s390-drivers.rst
> -F:	Documentation/s390/
> +F:	Documentation/arch/s390/
>   F:	arch/s390/
>   F:	drivers/s390/
>   F:	drivers/watchdog/diag288_wdt.c
> @@ -18703,7 +18703,7 @@ M:	Niklas Schnelle <schnelle@linux.ibm.com>
>   M:	Gerald Schaefer <gerald.schaefer@linux.ibm.com>
>   L:	linux-s390@vger.kernel.org
>   S:	Supported
> -F:	Documentation/s390/pci.rst
> +F:	Documentation/arch/s390/pci.rst
>   F:	arch/s390/pci/
>   F:	drivers/pci/hotplug/s390_pci_hpc.c
>   
> @@ -18720,7 +18720,7 @@ M:	Halil Pasic <pasic@linux.ibm.com>
>   M:	Jason Herne <jjherne@linux.ibm.com>
>   L:	linux-s390@vger.kernel.org
>   S:	Supported
> -F:	Documentation/s390/vfio-ap*
> +F:	Documentation/arch/s390/vfio-ap*
>   F:	drivers/s390/crypto/vfio_ap*
>   
>   S390 VFIO-CCW DRIVER
> @@ -18730,7 +18730,7 @@ R:	Halil Pasic <pasic@linux.ibm.com>
>   L:	linux-s390@vger.kernel.org
>   L:	kvm@vger.kernel.org
>   S:	Supported
> -F:	Documentation/s390/vfio-ccw.rst
> +F:	Documentation/arch/s390/vfio-ccw.rst
>   F:	drivers/s390/cio/vfio_ccw*
>   F:	include/uapi/linux/vfio_ccw.h
>   
> diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
> index 736548e4163e..286c1f9fb37c 100644
> --- a/arch/s390/Kconfig
> +++ b/arch/s390/Kconfig
> @@ -264,9 +264,9 @@ config ARCH_SUPPORTS_KEXEC_PURGATORY
>   config ARCH_SUPPORTS_CRASH_DUMP
>   	def_bool y
>   	help
> -	  Refer to <file:Documentation/s390/zfcpdump.rst> for more details on this.
> +	  Refer to <file:Documentation/arch/s390/zfcpdump.rst> for more details on this.
>   	  This option also enables s390 zfcpdump.
> -	  See also <file:Documentation/s390/zfcpdump.rst>
> +	  See also <file:Documentation/arch/s390/zfcpdump.rst>
>   
>   menu "Processor type and features"
>   
> diff --git a/arch/s390/include/asm/debug.h b/arch/s390/include/asm/debug.h
> index ac665b9670c5..ccd4e148b5ed 100644
> --- a/arch/s390/include/asm/debug.h
> +++ b/arch/s390/include/asm/debug.h
> @@ -222,7 +222,7 @@ static inline debug_entry_t *debug_text_event(debug_info_t *id, int level,
>   
>   /*
>    * IMPORTANT: Use "%s" in sprintf format strings with care! Only pointers are
> - * stored in the s390dbf. See Documentation/s390/s390dbf.rst for more details!
> + * stored in the s390dbf. See Documentation/arch/s390/s390dbf.rst for more details!
>    */
>   extern debug_entry_t *
>   __debug_sprintf_event(debug_info_t *id, int level, char *string, ...)
> @@ -350,7 +350,7 @@ static inline debug_entry_t *debug_text_exception(debug_info_t *id, int level,
>   
>   /*
>    * IMPORTANT: Use "%s" in sprintf format strings with care! Only pointers are
> - * stored in the s390dbf. See Documentation/s390/s390dbf.rst for more details!
> + * stored in the s390dbf. See Documentation/arch/s390/s390dbf.rst for more details!
>    */
>   extern debug_entry_t *
>   __debug_sprintf_exception(debug_info_t *id, int level, char *string, ...)
> diff --git a/drivers/s390/char/zcore.c b/drivers/s390/char/zcore.c
> index 942c73a11ca3..bc3be0330f1d 100644
> --- a/drivers/s390/char/zcore.c
> +++ b/drivers/s390/char/zcore.c
> @@ -3,7 +3,7 @@
>    * zcore module to export memory content and register sets for creating system
>    * dumps on SCSI/NVMe disks (zfcp/nvme dump).
>    *
> - * For more information please refer to Documentation/s390/zfcpdump.rst
> + * For more information please refer to Documentation/arch/s390/zfcpdump.rst
>    *
>    * Copyright IBM Corp. 2003, 2008
>    * Author(s): Michael Holzheu
> diff --git a/kernel/Kconfig.kexec b/kernel/Kconfig.kexec
> index ff72e45cfaef..fa45726d5619 100644
> --- a/kernel/Kconfig.kexec
> +++ b/kernel/Kconfig.kexec
> @@ -111,6 +111,6 @@ config CRASH_DUMP
>   	  For more details see Documentation/admin-guide/kdump/kdump.rst
>   
>   	  For s390, this option also enables zfcpdump.
> -	  See also <file:Documentation/s390/zfcpdump.rst>
> +	  See also <file:Documentation/arch/s390/zfcpdump.rst>
>   
>   endmenu
