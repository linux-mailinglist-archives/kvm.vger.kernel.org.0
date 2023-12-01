Return-Path: <kvm+bounces-3060-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7460E800309
	for <lists+kvm@lfdr.de>; Fri,  1 Dec 2023 06:34:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 29874281401
	for <lists+kvm@lfdr.de>; Fri,  1 Dec 2023 05:34:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C127A849C;
	Fri,  1 Dec 2023 05:34:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="I1dr1yBr"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4204E10FD
	for <kvm@vger.kernel.org>; Thu, 30 Nov 2023 21:34:25 -0800 (PST)
Received: from pps.filterd (m0353727.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3B15G9lg008159;
	Fri, 1 Dec 2023 05:33:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=qXW33Mjl0yUZ0LRSanku4XkKdXaZRbebZlcR92nnWqg=;
 b=I1dr1yBrPjm8pr4hW2ekYyUxLWRA5s5izvB1WO15OI5uyDD3Pv0GrQ8HDBcr/e3NsFos
 ah4fMkBGnowG+w5G06OCdH3sVDzyAR84wVXP/hJB9SLWRQHLucRBk0nggGn6X5aReHsZ
 eiJVJgRCr+jghk04OxzmDHBqNFR1oMWJYEiYgmS2H3sJwnA6BEC3O2h3ehGEKTPHaSCr
 D7ohvl91tZJAiDmJ4K7zNwUXT318hoS9QHucb1k4Hq8nalHJH7w3N3FfCspD3oyXBKc+
 rjm1LUshhi4Yyu0mseD1Swy4eDRD+TS3lWvlOOhrufNyWKjE90WIPPXiLcb1/Rw9PpLN Xg== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3uq4y75pvp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 01 Dec 2023 05:33:02 +0000
Received: from m0353727.ppops.net (m0353727.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3B15Kmci022446;
	Fri, 1 Dec 2023 05:33:01 GMT
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3uq4y75pus-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 01 Dec 2023 05:33:01 +0000
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3B12JXE3032423;
	Fri, 1 Dec 2023 05:13:17 GMT
Received: from smtprelay06.dal12v.mail.ibm.com ([172.16.1.8])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3ukv8p30jh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 01 Dec 2023 05:13:16 +0000
Received: from smtpav05.wdc07v.mail.ibm.com (smtpav05.wdc07v.mail.ibm.com [10.39.53.232])
	by smtprelay06.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3B15DFQS22807206
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 1 Dec 2023 05:13:15 GMT
Received: from smtpav05.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2B33058066;
	Fri,  1 Dec 2023 05:13:15 +0000 (GMT)
Received: from smtpav05.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id F3D6258043;
	Fri,  1 Dec 2023 05:12:44 +0000 (GMT)
Received: from [9.43.126.227] (unknown [9.43.126.227])
	by smtpav05.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Fri,  1 Dec 2023 05:12:44 +0000 (GMT)
Message-ID: <8f89fbbf-454b-c5e5-5e8f-46ea42ec20ed@linux.ibm.com>
Date: Fri, 1 Dec 2023 10:42:43 +0530
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.14.0
Subject: Re: [PATCH 1/6] system/cpus: rename qemu_mutex_lock_iothread() to
 qemu_bql_lock()
Content-Language: en-US
To: Stefan Hajnoczi <stefanha@redhat.com>, qemu-devel@nongnu.org
Cc: Jean-Christophe Dubois <jcd@tribudubois.net>,
        Fabiano Rosas <farosas@suse.de>, qemu-s390x@nongnu.org,
        Song Gao <gaosong@loongson.cn>,
        Marcel Apfelbaum
 <marcel.apfelbaum@gmail.com>,
        Thomas Huth <thuth@redhat.com>, Hyman Huang <yong.huang@smartx.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Andrey Smirnov <andrew.smirnov@gmail.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Kevin Wolf <kwolf@redhat.com>, Ilya Leoshkevich <iii@linux.ibm.com>,
        Artyom Tarasenko
 <atar4qemu@gmail.com>,
        Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>,
        Max Filippov <jcmvbkbc@gmail.com>,
        Alistair Francis <alistair.francis@wdc.com>,
        Paul Durrant <paul@xen.org>, Jagannathan Raman <jag.raman@oracle.com>,
        Juan Quintela
 <quintela@redhat.com>,
        =?UTF-8?Q?Daniel_P=2e_Berrang=c3=a9?=
 <berrange@redhat.com>,
        qemu-arm@nongnu.org, Jason Wang
 <jasowang@redhat.com>,
        Gerd Hoffmann <kraxel@redhat.com>, Hanna Reitz <hreitz@redhat.com>,
        =?UTF-8?Q?Marc-Andr=c3=a9_Lureau?= <marcandre.lureau@redhat.com>,
        BALATON Zoltan <balaton@eik.bme.hu>,
        Daniel Henrique Barboza <danielhb413@gmail.com>,
        Elena Ufimtseva <elena.ufimtseva@oracle.com>,
        Aurelien Jarno <aurelien@aurel32.net>,
        Hailiang Zhang <zhanghailiang@xfusion.com>,
        Roman Bolshakov <rbolshakov@ddn.com>,
        Huacai Chen <chenhuacai@kernel.org>, Fam Zheng <fam@euphon.net>,
        Eric Blake <eblake@redhat.com>, Jiri Slaby <jslaby@suse.cz>,
        Alexander Graf <agraf@csgraf.de>,
        Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
        Weiwei Li <liwei1518@gmail.com>, Eric Farman <farman@linux.ibm.com>,
        Stafford Horne <shorne@gmail.com>,
        David Hildenbrand <david@redhat.com>,
        Markus Armbruster <armbru@redhat.com>,
        Reinoud Zandijk <reinoud@netbsd.org>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Cameron Esfahani <dirty@apple.com>, xen-devel@lists.xenproject.org,
        Pavel Dovgalyuk <pavel.dovgaluk@ispras.ru>, qemu-riscv@nongnu.org,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        John Snow <jsnow@redhat.com>,
        Sunil Muthuswamy <sunilmut@microsoft.com>,
        Michael Roth <michael.roth@amd.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Bin Meng <bin.meng@windriver.com>,
        Stefano Stabellini <sstabellini@kernel.org>, kvm@vger.kernel.org,
        qemu-block@nongnu.org, Halil Pasic <pasic@linux.ibm.com>,
        Peter Xu <peterx@redhat.com>,
        Anthony Perard <anthony.perard@citrix.com>,
        =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>,
        Eduardo Habkost <eduardo@habkost.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vladimir Sementsov-Ogievskiy <vsementsov@yandex-team.ru>,
        =?UTF-8?Q?C=c3=a9dric_Le_Goater?= <clg@kaod.org>, qemu-ppc@nongnu.org,
        =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Akihiko Odaki <akihiko.odaki@daynix.com>,
        Leonardo Bras
 <leobras@redhat.com>,
        Nicholas Piggin <npiggin@gmail.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>
References: <20231129212625.1051502-1-stefanha@redhat.com>
 <20231129212625.1051502-2-stefanha@redhat.com>
From: Harsh Prateek Bora <harshpb@linux.ibm.com>
In-Reply-To: <20231129212625.1051502-2-stefanha@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: ExXjpJ3HkWQFGv5PgQ9IlNSyH2-bo_Rd
X-Proofpoint-ORIG-GUID: G-waGqm_eXCUbO3YgV2SSv88jsCqDMAg
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.997,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-12-01_03,2023-11-30_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 clxscore=1011
 mlxlogscore=999 impostorscore=0 adultscore=0 mlxscore=0 priorityscore=1501
 phishscore=0 bulkscore=0 suspectscore=0 malwarescore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311060000
 definitions=main-2312010031

Hi Stefan,

On 11/30/23 02:56, Stefan Hajnoczi wrote:
> The Big QEMU Lock (BQL) has many names and they are confusing. The
> actual QemuMutex variable is called qemu_global_mutex but it's commonly
> referred to as the BQL in discussions and some code comments. The
> locking APIs, however, are called qemu_mutex_lock_iothread() and
> qemu_mutex_unlock_iothread().
> 
> The "iothread" name is historic and comes from when the main thread was
> split into into KVM vcpu threads and the "iothread" (now called the main
> loop thread). I have contributed to the confusion myself by introducing
> a separate --object iothread, a separate concept unrelated to the BQL.
> 
> The "iothread" name is no longer appropriate for the BQL. Rename the
> locking APIs to:
> - void qemu_bql_lock(void)
> - void qemu_bql_unlock(void)
> - bool qemu_bql_locked(void)
> 
> There are more APIs with "iothread" in their names. Subsequent patches
> will rename them. There are also comments and documentation that will be
> updated in later patches.
> 
> Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>
> ---
>   include/block/aio-wait.h             |   2 +-
>   include/qemu/main-loop.h             |  26 +++---
>   accel/accel-blocker.c                |  10 +--
>   accel/dummy-cpus.c                   |   8 +-
>   accel/hvf/hvf-accel-ops.c            |   4 +-
>   accel/kvm/kvm-accel-ops.c            |   4 +-
>   accel/kvm/kvm-all.c                  |  22 ++---
>   accel/tcg/cpu-exec.c                 |  26 +++---
>   accel/tcg/cputlb.c                   |  16 ++--
>   accel/tcg/tcg-accel-ops-icount.c     |   4 +-
>   accel/tcg/tcg-accel-ops-mttcg.c      |  12 +--
>   accel/tcg/tcg-accel-ops-rr.c         |  14 ++--
>   accel/tcg/tcg-accel-ops.c            |   2 +-
>   accel/tcg/translate-all.c            |   2 +-
>   cpu-common.c                         |   4 +-
>   dump/dump.c                          |   4 +-
>   hw/core/cpu-common.c                 |   6 +-
>   hw/i386/intel_iommu.c                |   6 +-
>   hw/i386/kvm/xen_evtchn.c             |  16 ++--
>   hw/i386/kvm/xen_overlay.c            |   2 +-
>   hw/i386/kvm/xen_xenstore.c           |   2 +-
>   hw/intc/arm_gicv3_cpuif.c            |   2 +-
>   hw/intc/s390_flic.c                  |  18 ++--
>   hw/misc/edu.c                        |   4 +-
>   hw/misc/imx6_src.c                   |   2 +-
>   hw/misc/imx7_src.c                   |   2 +-
>   hw/net/xen_nic.c                     |   8 +-
>   hw/ppc/pegasos2.c                    |   2 +-
>   hw/ppc/ppc.c                         |   4 +-
>   hw/ppc/spapr.c                       |   2 +-
>   hw/ppc/spapr_rng.c                   |   4 +-
>   hw/ppc/spapr_softmmu.c               |   4 +-
>   hw/remote/mpqemu-link.c              |  12 +--
>   hw/remote/vfio-user-obj.c            |   2 +-
>   hw/s390x/s390-skeys.c                |   2 +-
>   migration/block-dirty-bitmap.c       |   4 +-
>   migration/block.c                    |  16 ++--
>   migration/colo.c                     |  60 +++++++-------
>   migration/dirtyrate.c                |  12 +--
>   migration/migration.c                |  52 ++++++------
>   migration/ram.c                      |  12 +--
>   replay/replay-internal.c             |   2 +-
>   semihosting/console.c                |   8 +-
>   stubs/iothread-lock.c                |   6 +-
>   system/cpu-throttle.c                |   4 +-
>   system/cpus.c                        |  28 +++----
>   system/dirtylimit.c                  |   4 +-
>   system/memory.c                      |   2 +-
>   system/physmem.c                     |   8 +-
>   system/runstate.c                    |   2 +-
>   system/watchpoint.c                  |   4 +-
>   target/arm/arm-powerctl.c            |  14 ++--
>   target/arm/helper.c                  |   4 +-
>   target/arm/hvf/hvf.c                 |   8 +-
>   target/arm/kvm.c                     |   4 +-
>   target/arm/kvm64.c                   |   4 +-
>   target/arm/ptw.c                     |   6 +-
>   target/arm/tcg/helper-a64.c          |   8 +-
>   target/arm/tcg/m_helper.c            |   4 +-
>   target/arm/tcg/op_helper.c           |  24 +++---
>   target/arm/tcg/psci.c                |   2 +-
>   target/hppa/int_helper.c             |   8 +-
>   target/i386/hvf/hvf.c                |   6 +-
>   target/i386/kvm/hyperv.c             |   4 +-
>   target/i386/kvm/kvm.c                |  28 +++----
>   target/i386/kvm/xen-emu.c            |  14 ++--
>   target/i386/nvmm/nvmm-accel-ops.c    |   4 +-
>   target/i386/nvmm/nvmm-all.c          |  20 ++---
>   target/i386/tcg/sysemu/fpu_helper.c  |   6 +-
>   target/i386/tcg/sysemu/misc_helper.c |   4 +-
>   target/i386/whpx/whpx-accel-ops.c    |   4 +-
>   target/i386/whpx/whpx-all.c          |  24 +++---
>   target/loongarch/csr_helper.c        |   4 +-
>   target/mips/kvm.c                    |   4 +-
>   target/mips/tcg/sysemu/cp0_helper.c  |   4 +-
>   target/openrisc/sys_helper.c         |  16 ++--
>   target/ppc/excp_helper.c             |  12 +--
>   target/ppc/kvm.c                     |   4 +-
>   target/ppc/misc_helper.c             |   8 +-
>   target/ppc/timebase_helper.c         |   8 +-
>   target/s390x/kvm/kvm.c               |   4 +-
>   target/s390x/tcg/misc_helper.c       | 118 +++++++++++++--------------
>   target/sparc/int32_helper.c          |   2 +-
>   target/sparc/int64_helper.c          |   6 +-
>   target/sparc/win_helper.c            |  20 ++---
>   target/xtensa/exc_helper.c           |   8 +-
>   ui/spice-core.c                      |   4 +-
>   util/async.c                         |   2 +-
>   util/main-loop.c                     |   8 +-
>   util/rcu.c                           |  14 ++--
>   audio/coreaudio.m                    |   4 +-
>   memory_ldst.c.inc                    |  18 ++--
>   target/i386/hvf/README.md            |   2 +-
>   ui/cocoa.m                           |  50 ++++++------
>   94 files changed, 502 insertions(+), 502 deletions(-)
> 


<snip>

>   
> diff --git a/hw/remote/mpqemu-link.c b/hw/remote/mpqemu-link.c
> index 9bd98e8219..ffb2c25145 100644
> --- a/hw/remote/mpqemu-link.c
> +++ b/hw/remote/mpqemu-link.c
> @@ -33,7 +33,7 @@
>    */
>   bool mpqemu_msg_send(MPQemuMsg *msg, QIOChannel *ioc, Error **errp)
>   {
> -    bool iolock = qemu_mutex_iothread_locked();
> +    bool iolock = qemu_bql_locked();

Should var name (one more below) be updated to reflect this update ?

Otherwise,

Reviewed-by: Harsh Prateek Bora <harshpb@linux.ibm.com>

>       bool iothread = qemu_in_iothread();
>       struct iovec send[2] = {};
>       int *fds = NULL;
> @@ -64,7 +64,7 @@ bool mpqemu_msg_send(MPQemuMsg *msg, QIOChannel *ioc, Error **errp)
>        * Also skip lock handling while in a co-routine in the main context.
>        */
>       if (iolock && !iothread && !qemu_in_coroutine()) {
> -        qemu_mutex_unlock_iothread();
> +        qemu_bql_unlock();
>       }
>   
>       if (!qio_channel_writev_full_all(ioc, send, G_N_ELEMENTS(send),
> @@ -76,7 +76,7 @@ bool mpqemu_msg_send(MPQemuMsg *msg, QIOChannel *ioc, Error **errp)
>   
>       if (iolock && !iothread && !qemu_in_coroutine()) {
>           /* See above comment why skip locking here. */
> -        qemu_mutex_lock_iothread();
> +        qemu_bql_lock();
>       }
>   
>       return ret;
> @@ -96,7 +96,7 @@ static ssize_t mpqemu_read(QIOChannel *ioc, void *buf, size_t len, int **fds,
>                              size_t *nfds, Error **errp)
>   {
>       struct iovec iov = { .iov_base = buf, .iov_len = len };
> -    bool iolock = qemu_mutex_iothread_locked();
> +    bool iolock = qemu_bql_locked();
>       bool iothread = qemu_in_iothread();
>       int ret = -1;
>   
> @@ -107,13 +107,13 @@ static ssize_t mpqemu_read(QIOChannel *ioc, void *buf, size_t len, int **fds,
>       assert(qemu_in_coroutine() || !iothread);
>   
>       if (iolock && !iothread && !qemu_in_coroutine()) {
> -        qemu_mutex_unlock_iothread();
> +        qemu_bql_unlock();
>       }
>   
>       ret = qio_channel_readv_full_all_eof(ioc, &iov, 1, fds, nfds, errp);
>   
>       if (iolock && !iothread && !qemu_in_coroutine()) {
> -        qemu_mutex_lock_iothread();
> +        qemu_bql_lock();
>       }
>   
>       return (ret <= 0) ? ret : iov.iov_len;
> diff --git a/hw/remote/vfio-user-obj.c b/hw/remote/vfio-user-obj.c
> index 8b10c32a3c..d0d0386d52 100644
> --- a/hw/remote/vfio-user-obj.c
> +++ b/hw/remote/vfio-user-obj.c
> @@ -400,7 +400,7 @@ static int vfu_object_mr_rw(MemoryRegion *mr, uint8_t *buf, hwaddr offset,
>           }
>   
>           if (release_lock) {
> -            qemu_mutex_unlock_iothread();
> +            qemu_bql_unlock();
>               release_lock = false;
>           }
>   
> diff --git a/hw/s390x/s390-skeys.c b/hw/s390x/s390-skeys.c
> index 8f5159d85d..307344aa80 100644
> --- a/hw/s390x/s390-skeys.c
> +++ b/hw/s390x/s390-skeys.c
> @@ -153,7 +153,7 @@ void qmp_dump_skeys(const char *filename, Error **errp)
>           goto out;
>       }
>   
> -    assert(qemu_mutex_iothread_locked());
> +    assert(qemu_bql_locked());
>       guest_phys_blocks_init(&guest_phys_blocks);
>       guest_phys_blocks_append(&guest_phys_blocks);
>   
> diff --git a/migration/block-dirty-bitmap.c b/migration/block-dirty-bitmap.c
> index 24347ab0f7..b5a2d377db 100644
> --- a/migration/block-dirty-bitmap.c
> +++ b/migration/block-dirty-bitmap.c
> @@ -774,7 +774,7 @@ static void dirty_bitmap_state_pending(void *opaque,
>       SaveBitmapState *dbms;
>       uint64_t pending = 0;
>   
> -    qemu_mutex_lock_iothread();
> +    qemu_bql_lock();
>   
>       QSIMPLEQ_FOREACH(dbms, &s->dbms_list, entry) {
>           uint64_t gran = bdrv_dirty_bitmap_granularity(dbms->bitmap);
> @@ -784,7 +784,7 @@ static void dirty_bitmap_state_pending(void *opaque,
>           pending += DIV_ROUND_UP(sectors * BDRV_SECTOR_SIZE, gran);
>       }
>   
> -    qemu_mutex_unlock_iothread();
> +    qemu_bql_unlock();
>   
>       trace_dirty_bitmap_state_pending(pending);
>   
> diff --git a/migration/block.c b/migration/block.c
> index a15f9bddcb..87f36e6e35 100644
> --- a/migration/block.c
> +++ b/migration/block.c
> @@ -269,7 +269,7 @@ static int mig_save_device_bulk(QEMUFile *f, BlkMigDevState *bmds)
>       int64_t count;
>   
>       if (bmds->shared_base) {
> -        qemu_mutex_lock_iothread();
> +        qemu_bql_lock();
>           aio_context_acquire(blk_get_aio_context(bb));
>           /* Skip unallocated sectors; intentionally treats failure or
>            * partial sector as an allocated sector */
> @@ -282,7 +282,7 @@ static int mig_save_device_bulk(QEMUFile *f, BlkMigDevState *bmds)
>               cur_sector += count >> BDRV_SECTOR_BITS;
>           }
>           aio_context_release(blk_get_aio_context(bb));
> -        qemu_mutex_unlock_iothread();
> +        qemu_bql_unlock();
>       }
>   
>       if (cur_sector >= total_sectors) {
> @@ -321,14 +321,14 @@ static int mig_save_device_bulk(QEMUFile *f, BlkMigDevState *bmds)
>        * This is ugly and will disappear when we make bdrv_* thread-safe,
>        * without the need to acquire the AioContext.
>        */
> -    qemu_mutex_lock_iothread();
> +    qemu_bql_lock();
>       aio_context_acquire(blk_get_aio_context(bmds->blk));
>       bdrv_reset_dirty_bitmap(bmds->dirty_bitmap, cur_sector * BDRV_SECTOR_SIZE,
>                               nr_sectors * BDRV_SECTOR_SIZE);
>       blk->aiocb = blk_aio_preadv(bb, cur_sector * BDRV_SECTOR_SIZE, &blk->qiov,
>                                   0, blk_mig_read_cb, blk);
>       aio_context_release(blk_get_aio_context(bmds->blk));
> -    qemu_mutex_unlock_iothread();
> +    qemu_bql_unlock();
>   
>       bmds->cur_sector = cur_sector + nr_sectors;
>       return (bmds->cur_sector >= total_sectors);
> @@ -786,9 +786,9 @@ static int block_save_iterate(QEMUFile *f, void *opaque)
>               /* Always called with iothread lock taken for
>                * simplicity, block_save_complete also calls it.
>                */
> -            qemu_mutex_lock_iothread();
> +            qemu_bql_lock();
>               ret = blk_mig_save_dirty_block(f, 1);
> -            qemu_mutex_unlock_iothread();
> +            qemu_bql_unlock();
>           }
>           if (ret < 0) {
>               return ret;
> @@ -860,9 +860,9 @@ static void block_state_pending(void *opaque, uint64_t *must_precopy,
>       /* Estimate pending number of bytes to send */
>       uint64_t pending;
>   
> -    qemu_mutex_lock_iothread();
> +    qemu_bql_lock();
>       pending = get_remaining_dirty();
> -    qemu_mutex_unlock_iothread();
> +    qemu_bql_unlock();
>   
>       blk_mig_lock();
>       pending += block_mig_state.submitted * BLK_MIG_BLOCK_SIZE +
> diff --git a/migration/colo.c b/migration/colo.c
> index 4447e34914..2e68107cfa 100644
> --- a/migration/colo.c
> +++ b/migration/colo.c
> @@ -420,13 +420,13 @@ static int colo_do_checkpoint_transaction(MigrationState *s,
>       qio_channel_io_seek(QIO_CHANNEL(bioc), 0, 0, NULL);
>       bioc->usage = 0;
>   
> -    qemu_mutex_lock_iothread();
> +    qemu_bql_lock();
>       if (failover_get_state() != FAILOVER_STATUS_NONE) {
> -        qemu_mutex_unlock_iothread();
> +        qemu_bql_unlock();
>           goto out;
>       }
>       vm_stop_force_state(RUN_STATE_COLO);
> -    qemu_mutex_unlock_iothread();
> +    qemu_bql_unlock();
>       trace_colo_vm_state_change("run", "stop");
>       /*
>        * Failover request bh could be called after vm_stop_force_state(),
> @@ -435,23 +435,23 @@ static int colo_do_checkpoint_transaction(MigrationState *s,
>       if (failover_get_state() != FAILOVER_STATUS_NONE) {
>           goto out;
>       }
> -    qemu_mutex_lock_iothread();
> +    qemu_bql_lock();
>   
>       replication_do_checkpoint_all(&local_err);
>       if (local_err) {
> -        qemu_mutex_unlock_iothread();
> +        qemu_bql_unlock();
>           goto out;
>       }
>   
>       colo_send_message(s->to_dst_file, COLO_MESSAGE_VMSTATE_SEND, &local_err);
>       if (local_err) {
> -        qemu_mutex_unlock_iothread();
> +        qemu_bql_unlock();
>           goto out;
>       }
>       /* Note: device state is saved into buffer */
>       ret = qemu_save_device_state(fb);
>   
> -    qemu_mutex_unlock_iothread();
> +    qemu_bql_unlock();
>       if (ret < 0) {
>           goto out;
>       }
> @@ -504,9 +504,9 @@ static int colo_do_checkpoint_transaction(MigrationState *s,
>   
>       ret = 0;
>   
> -    qemu_mutex_lock_iothread();
> +    qemu_bql_lock();
>       vm_start();
> -    qemu_mutex_unlock_iothread();
> +    qemu_bql_unlock();
>       trace_colo_vm_state_change("stop", "run");
>   
>   out:
> @@ -557,15 +557,15 @@ static void colo_process_checkpoint(MigrationState *s)
>       fb = qemu_file_new_output(QIO_CHANNEL(bioc));
>       object_unref(OBJECT(bioc));
>   
> -    qemu_mutex_lock_iothread();
> +    qemu_bql_lock();
>       replication_start_all(REPLICATION_MODE_PRIMARY, &local_err);
>       if (local_err) {
> -        qemu_mutex_unlock_iothread();
> +        qemu_bql_unlock();
>           goto out;
>       }
>   
>       vm_start();
> -    qemu_mutex_unlock_iothread();
> +    qemu_bql_unlock();
>       trace_colo_vm_state_change("stop", "run");
>   
>       timer_mod(s->colo_delay_timer, qemu_clock_get_ms(QEMU_CLOCK_HOST) +
> @@ -639,14 +639,14 @@ out:
>   
>   void migrate_start_colo_process(MigrationState *s)
>   {
> -    qemu_mutex_unlock_iothread();
> +    qemu_bql_unlock();
>       qemu_event_init(&s->colo_checkpoint_event, false);
>       s->colo_delay_timer =  timer_new_ms(QEMU_CLOCK_HOST,
>                                   colo_checkpoint_notify, s);
>   
>       qemu_sem_init(&s->colo_exit_sem, 0);
>       colo_process_checkpoint(s);
> -    qemu_mutex_lock_iothread();
> +    qemu_bql_lock();
>   }
>   
>   static void colo_incoming_process_checkpoint(MigrationIncomingState *mis,
> @@ -657,9 +657,9 @@ static void colo_incoming_process_checkpoint(MigrationIncomingState *mis,
>       Error *local_err = NULL;
>       int ret;
>   
> -    qemu_mutex_lock_iothread();
> +    qemu_bql_lock();
>       vm_stop_force_state(RUN_STATE_COLO);
> -    qemu_mutex_unlock_iothread();
> +    qemu_bql_unlock();
>       trace_colo_vm_state_change("run", "stop");
>   
>       /* FIXME: This is unnecessary for periodic checkpoint mode */
> @@ -677,10 +677,10 @@ static void colo_incoming_process_checkpoint(MigrationIncomingState *mis,
>           return;
>       }
>   
> -    qemu_mutex_lock_iothread();
> +    qemu_bql_lock();
>       cpu_synchronize_all_states();
>       ret = qemu_loadvm_state_main(mis->from_src_file, mis);
> -    qemu_mutex_unlock_iothread();
> +    qemu_bql_unlock();
>   
>       if (ret < 0) {
>           error_setg(errp, "Load VM's live state (ram) error");
> @@ -719,14 +719,14 @@ static void colo_incoming_process_checkpoint(MigrationIncomingState *mis,
>           return;
>       }
>   
> -    qemu_mutex_lock_iothread();
> +    qemu_bql_lock();
>       vmstate_loading = true;
>       colo_flush_ram_cache();
>       ret = qemu_load_device_state(fb);
>       if (ret < 0) {
>           error_setg(errp, "COLO: load device state failed");
>           vmstate_loading = false;
> -        qemu_mutex_unlock_iothread();
> +        qemu_bql_unlock();
>           return;
>       }
>   
> @@ -734,7 +734,7 @@ static void colo_incoming_process_checkpoint(MigrationIncomingState *mis,
>       if (local_err) {
>           error_propagate(errp, local_err);
>           vmstate_loading = false;
> -        qemu_mutex_unlock_iothread();
> +        qemu_bql_unlock();
>           return;
>       }
>   
> @@ -743,7 +743,7 @@ static void colo_incoming_process_checkpoint(MigrationIncomingState *mis,
>       if (local_err) {
>           error_propagate(errp, local_err);
>           vmstate_loading = false;
> -        qemu_mutex_unlock_iothread();
> +        qemu_bql_unlock();
>           return;
>       }
>       /* Notify all filters of all NIC to do checkpoint */
> @@ -752,13 +752,13 @@ static void colo_incoming_process_checkpoint(MigrationIncomingState *mis,
>       if (local_err) {
>           error_propagate(errp, local_err);
>           vmstate_loading = false;
> -        qemu_mutex_unlock_iothread();
> +        qemu_bql_unlock();
>           return;
>       }
>   
>       vmstate_loading = false;
>       vm_start();
> -    qemu_mutex_unlock_iothread();
> +    qemu_bql_unlock();
>       trace_colo_vm_state_change("stop", "run");
>   
>       if (failover_get_state() == FAILOVER_STATUS_RELAUNCH) {
> @@ -851,14 +851,14 @@ static void *colo_process_incoming_thread(void *opaque)
>       fb = qemu_file_new_input(QIO_CHANNEL(bioc));
>       object_unref(OBJECT(bioc));
>   
> -    qemu_mutex_lock_iothread();
> +    qemu_bql_lock();
>       replication_start_all(REPLICATION_MODE_SECONDARY, &local_err);
>       if (local_err) {
> -        qemu_mutex_unlock_iothread();
> +        qemu_bql_unlock();
>           goto out;
>       }
>       vm_start();
> -    qemu_mutex_unlock_iothread();
> +    qemu_bql_unlock();
>       trace_colo_vm_state_change("stop", "run");
>   
>       colo_send_message(mis->to_src_file, COLO_MESSAGE_CHECKPOINT_READY,
> @@ -920,7 +920,7 @@ int coroutine_fn colo_incoming_co(void)
>       Error *local_err = NULL;
>       QemuThread th;
>   
> -    assert(qemu_mutex_iothread_locked());
> +    assert(qemu_bql_locked());
>   
>       if (!migration_incoming_colo_enabled()) {
>           return 0;
> @@ -940,10 +940,10 @@ int coroutine_fn colo_incoming_co(void)
>       qemu_coroutine_yield();
>       mis->colo_incoming_co = NULL;
>   
> -    qemu_mutex_unlock_iothread();
> +    qemu_bql_unlock();
>       /* Wait checkpoint incoming thread exit before free resource */
>       qemu_thread_join(&th);
> -    qemu_mutex_lock_iothread();
> +    qemu_bql_lock();
>   
>       /* We hold the global iothread lock, so it is safe here */
>       colo_release_ram_cache();
> diff --git a/migration/dirtyrate.c b/migration/dirtyrate.c
> index 036ac017fc..1d705092cd 100644
> --- a/migration/dirtyrate.c
> +++ b/migration/dirtyrate.c
> @@ -90,13 +90,13 @@ static int64_t do_calculate_dirtyrate(DirtyPageRecord dirty_pages,
>   
>   void global_dirty_log_change(unsigned int flag, bool start)
>   {
> -    qemu_mutex_lock_iothread();
> +    qemu_bql_lock();
>       if (start) {
>           memory_global_dirty_log_start(flag);
>       } else {
>           memory_global_dirty_log_stop(flag);
>       }
> -    qemu_mutex_unlock_iothread();
> +    qemu_bql_unlock();
>   }
>   
>   /*
> @@ -106,12 +106,12 @@ void global_dirty_log_change(unsigned int flag, bool start)
>    */
>   static void global_dirty_log_sync(unsigned int flag, bool one_shot)
>   {
> -    qemu_mutex_lock_iothread();
> +    qemu_bql_lock();
>       memory_global_dirty_log_sync(false);
>       if (one_shot) {
>           memory_global_dirty_log_stop(flag);
>       }
> -    qemu_mutex_unlock_iothread();
> +    qemu_bql_unlock();
>   }
>   
>   static DirtyPageRecord *vcpu_dirty_stat_alloc(VcpuStat *stat)
> @@ -610,7 +610,7 @@ static void calculate_dirtyrate_dirty_bitmap(struct DirtyRateConfig config)
>       int64_t start_time;
>       DirtyPageRecord dirty_pages;
>   
> -    qemu_mutex_lock_iothread();
> +    qemu_bql_lock();
>       memory_global_dirty_log_start(GLOBAL_DIRTY_DIRTY_RATE);
>   
>       /*
> @@ -627,7 +627,7 @@ static void calculate_dirtyrate_dirty_bitmap(struct DirtyRateConfig config)
>        * KVM_DIRTY_LOG_MANUAL_PROTECT_ENABLE cap is enabled.
>        */
>       dirtyrate_manual_reset_protect();
> -    qemu_mutex_unlock_iothread();
> +    qemu_bql_unlock();
>   
>       record_dirtypages_bitmap(&dirty_pages, true);
>   
> diff --git a/migration/migration.c b/migration/migration.c
> index 28a34c9068..b153133fba 100644
> --- a/migration/migration.c
> +++ b/migration/migration.c
> @@ -1293,12 +1293,12 @@ static void migrate_fd_cleanup(MigrationState *s)
>           QEMUFile *tmp;
>   
>           trace_migrate_fd_cleanup();
> -        qemu_mutex_unlock_iothread();
> +        qemu_bql_unlock();
>           if (s->migration_thread_running) {
>               qemu_thread_join(&s->thread);
>               s->migration_thread_running = false;
>           }
> -        qemu_mutex_lock_iothread();
> +        qemu_bql_lock();
>   
>           multifd_save_cleanup();
>           qemu_mutex_lock(&s->qemu_file_lock);
> @@ -2410,7 +2410,7 @@ static int postcopy_start(MigrationState *ms, Error **errp)
>       }
>   
>       trace_postcopy_start();
> -    qemu_mutex_lock_iothread();
> +    qemu_bql_lock();
>       trace_postcopy_start_set_run();
>   
>       migration_downtime_start(ms);
> @@ -2519,7 +2519,7 @@ static int postcopy_start(MigrationState *ms, Error **errp)
>   
>       migration_downtime_end(ms);
>   
> -    qemu_mutex_unlock_iothread();
> +    qemu_bql_unlock();
>   
>       if (migrate_postcopy_ram()) {
>           /*
> @@ -2560,7 +2560,7 @@ fail:
>               error_report_err(local_err);
>           }
>       }
> -    qemu_mutex_unlock_iothread();
> +    qemu_bql_unlock();
>       return -1;
>   }
>   
> @@ -2594,14 +2594,14 @@ static int migration_maybe_pause(MigrationState *s,
>        * wait for the 'pause_sem' semaphore.
>        */
>       if (s->state != MIGRATION_STATUS_CANCELLING) {
> -        qemu_mutex_unlock_iothread();
> +        qemu_bql_unlock();
>           migrate_set_state(&s->state, *current_active_state,
>                             MIGRATION_STATUS_PRE_SWITCHOVER);
>           qemu_sem_wait(&s->pause_sem);
>           migrate_set_state(&s->state, MIGRATION_STATUS_PRE_SWITCHOVER,
>                             new_state);
>           *current_active_state = new_state;
> -        qemu_mutex_lock_iothread();
> +        qemu_bql_lock();
>       }
>   
>       return s->state == new_state ? 0 : -EINVAL;
> @@ -2612,7 +2612,7 @@ static int migration_completion_precopy(MigrationState *s,
>   {
>       int ret;
>   
> -    qemu_mutex_lock_iothread();
> +    qemu_bql_lock();
>       migration_downtime_start(s);
>       qemu_system_wakeup_request(QEMU_WAKEUP_REASON_OTHER, NULL);
>   
> @@ -2640,7 +2640,7 @@ static int migration_completion_precopy(MigrationState *s,
>       ret = qemu_savevm_state_complete_precopy(s->to_dst_file, false,
>                                                s->block_inactive);
>   out_unlock:
> -    qemu_mutex_unlock_iothread();
> +    qemu_bql_unlock();
>       return ret;
>   }
>   
> @@ -2648,9 +2648,9 @@ static void migration_completion_postcopy(MigrationState *s)
>   {
>       trace_migration_completion_postcopy_end();
>   
> -    qemu_mutex_lock_iothread();
> +    qemu_bql_lock();
>       qemu_savevm_state_complete_postcopy(s->to_dst_file);
> -    qemu_mutex_unlock_iothread();
> +    qemu_bql_unlock();
>   
>       /*
>        * Shutdown the postcopy fast path thread.  This is only needed when dest
> @@ -2674,14 +2674,14 @@ static void migration_completion_failed(MigrationState *s,
>            */
>           Error *local_err = NULL;
>   
> -        qemu_mutex_lock_iothread();
> +        qemu_bql_lock();
>           bdrv_activate_all(&local_err);
>           if (local_err) {
>               error_report_err(local_err);
>           } else {
>               s->block_inactive = false;
>           }
> -        qemu_mutex_unlock_iothread();
> +        qemu_bql_unlock();
>       }
>   
>       migrate_set_state(&s->state, current_active_state,
> @@ -3121,7 +3121,7 @@ static void migration_iteration_finish(MigrationState *s)
>       /* If we enabled cpu throttling for auto-converge, turn it off. */
>       cpu_throttle_stop();
>   
> -    qemu_mutex_lock_iothread();
> +    qemu_bql_lock();
>       switch (s->state) {
>       case MIGRATION_STATUS_COMPLETED:
>           migration_calculate_complete(s);
> @@ -3152,7 +3152,7 @@ static void migration_iteration_finish(MigrationState *s)
>           break;
>       }
>       migrate_fd_cleanup_schedule(s);
> -    qemu_mutex_unlock_iothread();
> +    qemu_bql_unlock();
>   }
>   
>   static void bg_migration_iteration_finish(MigrationState *s)
> @@ -3164,7 +3164,7 @@ static void bg_migration_iteration_finish(MigrationState *s)
>        */
>       ram_write_tracking_stop();
>   
> -    qemu_mutex_lock_iothread();
> +    qemu_bql_lock();
>       switch (s->state) {
>       case MIGRATION_STATUS_COMPLETED:
>           migration_calculate_complete(s);
> @@ -3183,7 +3183,7 @@ static void bg_migration_iteration_finish(MigrationState *s)
>       }
>   
>       migrate_fd_cleanup_schedule(s);
> -    qemu_mutex_unlock_iothread();
> +    qemu_bql_unlock();
>   }
>   
>   /*
> @@ -3305,9 +3305,9 @@ static void *migration_thread(void *opaque)
>       object_ref(OBJECT(s));
>       update_iteration_initial_status(s);
>   
> -    qemu_mutex_lock_iothread();
> +    qemu_bql_lock();
>       qemu_savevm_state_header(s->to_dst_file);
> -    qemu_mutex_unlock_iothread();
> +    qemu_bql_unlock();
>   
>       /*
>        * If we opened the return path, we need to make sure dst has it
> @@ -3335,9 +3335,9 @@ static void *migration_thread(void *opaque)
>           qemu_savevm_send_colo_enable(s->to_dst_file);
>       }
>   
> -    qemu_mutex_lock_iothread();
> +    qemu_bql_lock();
>       qemu_savevm_state_setup(s->to_dst_file);
> -    qemu_mutex_unlock_iothread();
> +    qemu_bql_unlock();
>   
>       qemu_savevm_wait_unplug(s, MIGRATION_STATUS_SETUP,
>                                  MIGRATION_STATUS_ACTIVE);
> @@ -3448,10 +3448,10 @@ static void *bg_migration_thread(void *opaque)
>       ram_write_tracking_prepare();
>   #endif
>   
> -    qemu_mutex_lock_iothread();
> +    qemu_bql_lock();
>       qemu_savevm_state_header(s->to_dst_file);
>       qemu_savevm_state_setup(s->to_dst_file);
> -    qemu_mutex_unlock_iothread();
> +    qemu_bql_unlock();
>   
>       qemu_savevm_wait_unplug(s, MIGRATION_STATUS_SETUP,
>                                  MIGRATION_STATUS_ACTIVE);
> @@ -3461,7 +3461,7 @@ static void *bg_migration_thread(void *opaque)
>       trace_migration_thread_setup_complete();
>       migration_downtime_start(s);
>   
> -    qemu_mutex_lock_iothread();
> +    qemu_bql_lock();
>   
>       /*
>        * If VM is currently in suspended state, then, to make a valid runstate
> @@ -3504,7 +3504,7 @@ static void *bg_migration_thread(void *opaque)
>       s->vm_start_bh = qemu_bh_new(bg_migration_vm_start_bh, s);
>       qemu_bh_schedule(s->vm_start_bh);
>   
> -    qemu_mutex_unlock_iothread();
> +    qemu_bql_unlock();
>   
>       while (migration_is_active(s)) {
>           MigIterateState iter_state = bg_migration_iteration_run(s);
> @@ -3533,7 +3533,7 @@ fail:
>       if (early_fail) {
>           migrate_set_state(&s->state, MIGRATION_STATUS_ACTIVE,
>                   MIGRATION_STATUS_FAILED);
> -        qemu_mutex_unlock_iothread();
> +        qemu_bql_unlock();
>       }
>   
>       bg_migration_iteration_finish(s);
> diff --git a/migration/ram.c b/migration/ram.c
> index 8c7886ab79..f274bcf655 100644
> --- a/migration/ram.c
> +++ b/migration/ram.c
> @@ -2984,9 +2984,9 @@ static int ram_save_setup(QEMUFile *f, void *opaque)
>       migration_ops = g_malloc0(sizeof(MigrationOps));
>       migration_ops->ram_save_target_page = ram_save_target_page_legacy;
>   
> -    qemu_mutex_unlock_iothread();
> +    qemu_bql_unlock();
>       ret = multifd_send_sync_main(f);
> -    qemu_mutex_lock_iothread();
> +    qemu_bql_lock();
>       if (ret < 0) {
>           return ret;
>       }
> @@ -3221,11 +3221,11 @@ static void ram_state_pending_exact(void *opaque, uint64_t *must_precopy,
>       uint64_t remaining_size = rs->migration_dirty_pages * TARGET_PAGE_SIZE;
>   
>       if (!migration_in_postcopy() && remaining_size < s->threshold_size) {
> -        qemu_mutex_lock_iothread();
> +        qemu_bql_lock();
>           WITH_RCU_READ_LOCK_GUARD() {
>               migration_bitmap_sync_precopy(rs, false);
>           }
> -        qemu_mutex_unlock_iothread();
> +        qemu_bql_unlock();
>           remaining_size = rs->migration_dirty_pages * TARGET_PAGE_SIZE;
>       }
>   
> @@ -3453,7 +3453,7 @@ void colo_incoming_start_dirty_log(void)
>   {
>       RAMBlock *block = NULL;
>       /* For memory_global_dirty_log_start below. */
> -    qemu_mutex_lock_iothread();
> +    qemu_bql_lock();
>       qemu_mutex_lock_ramlist();
>   
>       memory_global_dirty_log_sync(false);
> @@ -3467,7 +3467,7 @@ void colo_incoming_start_dirty_log(void)
>       }
>       ram_state->migration_dirty_pages = 0;
>       qemu_mutex_unlock_ramlist();
> -    qemu_mutex_unlock_iothread();
> +    qemu_bql_unlock();
>   }
>   
>   /* It is need to hold the global lock to call this helper */
> diff --git a/replay/replay-internal.c b/replay/replay-internal.c
> index 77d0c82327..04c9c6374b 100644
> --- a/replay/replay-internal.c
> +++ b/replay/replay-internal.c
> @@ -216,7 +216,7 @@ void replay_mutex_lock(void)
>   {
>       if (replay_mode != REPLAY_MODE_NONE) {
>           unsigned long id;
> -        g_assert(!qemu_mutex_iothread_locked());
> +        g_assert(!qemu_bql_locked());
>           g_assert(!replay_mutex_locked());
>           qemu_mutex_lock(&lock);
>           id = mutex_tail++;
> diff --git a/semihosting/console.c b/semihosting/console.c
> index 5d61e8207e..666285541d 100644
> --- a/semihosting/console.c
> +++ b/semihosting/console.c
> @@ -43,7 +43,7 @@ static SemihostingConsole console;
>   static int console_can_read(void *opaque)
>   {
>       SemihostingConsole *c = opaque;
> -    g_assert(qemu_mutex_iothread_locked());
> +    g_assert(qemu_bql_locked());
>       return (int)fifo8_num_free(&c->fifo);
>   }
>   
> @@ -58,7 +58,7 @@ static void console_wake_up(gpointer data, gpointer user_data)
>   static void console_read(void *opaque, const uint8_t *buf, int size)
>   {
>       SemihostingConsole *c = opaque;
> -    g_assert(qemu_mutex_iothread_locked());
> +    g_assert(qemu_bql_locked());
>       while (size-- && !fifo8_is_full(&c->fifo)) {
>           fifo8_push(&c->fifo, *buf++);
>       }
> @@ -70,7 +70,7 @@ bool qemu_semihosting_console_ready(void)
>   {
>       SemihostingConsole *c = &console;
>   
> -    g_assert(qemu_mutex_iothread_locked());
> +    g_assert(qemu_bql_locked());
>       return !fifo8_is_empty(&c->fifo);
>   }
>   
> @@ -78,7 +78,7 @@ void qemu_semihosting_console_block_until_ready(CPUState *cs)
>   {
>       SemihostingConsole *c = &console;
>   
> -    g_assert(qemu_mutex_iothread_locked());
> +    g_assert(qemu_bql_locked());
>   
>       /* Block if the fifo is completely empty. */
>       if (fifo8_is_empty(&c->fifo)) {
> diff --git a/stubs/iothread-lock.c b/stubs/iothread-lock.c
> index 5b45b7fc8b..1f24c3203a 100644
> --- a/stubs/iothread-lock.c
> +++ b/stubs/iothread-lock.c
> @@ -1,15 +1,15 @@
>   #include "qemu/osdep.h"
>   #include "qemu/main-loop.h"
>   
> -bool qemu_mutex_iothread_locked(void)
> +bool qemu_bql_locked(void)
>   {
>       return false;
>   }
>   
> -void qemu_mutex_lock_iothread_impl(const char *file, int line)
> +void qemu_bql_lock_impl(const char *file, int line)
>   {
>   }
>   
> -void qemu_mutex_unlock_iothread(void)
> +void qemu_bql_unlock(void)
>   {
>   }
> diff --git a/system/cpu-throttle.c b/system/cpu-throttle.c
> index d9bb30a223..e98836311b 100644
> --- a/system/cpu-throttle.c
> +++ b/system/cpu-throttle.c
> @@ -57,9 +57,9 @@ static void cpu_throttle_thread(CPUState *cpu, run_on_cpu_data opaque)
>               qemu_cond_timedwait_iothread(cpu->halt_cond,
>                                            sleeptime_ns / SCALE_MS);
>           } else {
> -            qemu_mutex_unlock_iothread();
> +            qemu_bql_unlock();
>               g_usleep(sleeptime_ns / SCALE_US);
> -            qemu_mutex_lock_iothread();
> +            qemu_bql_lock();
>           }
>           sleeptime_ns = endtime_ns - qemu_clock_get_ns(QEMU_CLOCK_REALTIME);
>       }
> diff --git a/system/cpus.c b/system/cpus.c
> index a444a747f0..d5b98c11f5 100644
> --- a/system/cpus.c
> +++ b/system/cpus.c
> @@ -481,35 +481,35 @@ bool qemu_in_vcpu_thread(void)
>       return current_cpu && qemu_cpu_is_self(current_cpu);
>   }
>   
> -QEMU_DEFINE_STATIC_CO_TLS(bool, iothread_locked)
> +QEMU_DEFINE_STATIC_CO_TLS(bool, bql_locked)
>   
> -bool qemu_mutex_iothread_locked(void)
> +bool qemu_bql_locked(void)
>   {
> -    return get_iothread_locked();
> +    return get_bql_locked();
>   }
>   
>   bool qemu_in_main_thread(void)
>   {
> -    return qemu_mutex_iothread_locked();
> +    return qemu_bql_locked();
>   }
>   
>   /*
>    * The BQL is taken from so many places that it is worth profiling the
>    * callers directly, instead of funneling them all through a single function.
>    */
> -void qemu_mutex_lock_iothread_impl(const char *file, int line)
> +void qemu_bql_lock_impl(const char *file, int line)
>   {
>       QemuMutexLockFunc bql_lock = qatomic_read(&qemu_bql_mutex_lock_func);
>   
> -    g_assert(!qemu_mutex_iothread_locked());
> +    g_assert(!qemu_bql_locked());
>       bql_lock(&qemu_global_mutex, file, line);
> -    set_iothread_locked(true);
> +    set_bql_locked(true);
>   }
>   
> -void qemu_mutex_unlock_iothread(void)
> +void qemu_bql_unlock(void)
>   {
> -    g_assert(qemu_mutex_iothread_locked());
> -    set_iothread_locked(false);
> +    g_assert(qemu_bql_locked());
> +    set_bql_locked(false);
>       qemu_mutex_unlock(&qemu_global_mutex);
>   }
>   
> @@ -577,9 +577,9 @@ void pause_all_vcpus(void)
>           }
>       }
>   
> -    qemu_mutex_unlock_iothread();
> +    qemu_bql_unlock();
>       replay_mutex_lock();
> -    qemu_mutex_lock_iothread();
> +    qemu_bql_lock();
>   }
>   
>   void cpu_resume(CPUState *cpu)
> @@ -608,9 +608,9 @@ void cpu_remove_sync(CPUState *cpu)
>       cpu->stop = true;
>       cpu->unplug = true;
>       qemu_cpu_kick(cpu);
> -    qemu_mutex_unlock_iothread();
> +    qemu_bql_unlock();
>       qemu_thread_join(cpu->thread);
> -    qemu_mutex_lock_iothread();
> +    qemu_bql_lock();
>   }
>   
>   void cpus_register_accel(const AccelOpsClass *ops)
> diff --git a/system/dirtylimit.c b/system/dirtylimit.c
> index 495c7a7082..f89bf6b61f 100644
> --- a/system/dirtylimit.c
> +++ b/system/dirtylimit.c
> @@ -148,9 +148,9 @@ void vcpu_dirty_rate_stat_stop(void)
>   {
>       qatomic_set(&vcpu_dirty_rate_stat->running, 0);
>       dirtylimit_state_unlock();
> -    qemu_mutex_unlock_iothread();
> +    qemu_bql_unlock();
>       qemu_thread_join(&vcpu_dirty_rate_stat->thread);
> -    qemu_mutex_lock_iothread();
> +    qemu_bql_lock();
>       dirtylimit_state_lock();
>   }
>   
> diff --git a/system/memory.c b/system/memory.c
> index 4d9cb0a7ff..8d78334cb2 100644
> --- a/system/memory.c
> +++ b/system/memory.c
> @@ -1119,7 +1119,7 @@ void memory_region_transaction_commit(void)
>       AddressSpace *as;
>   
>       assert(memory_region_transaction_depth);
> -    assert(qemu_mutex_iothread_locked());
> +    assert(qemu_bql_locked());
>   
>       --memory_region_transaction_depth;
>       if (!memory_region_transaction_depth) {
> diff --git a/system/physmem.c b/system/physmem.c
> index a63853a7bc..c136675876 100644
> --- a/system/physmem.c
> +++ b/system/physmem.c
> @@ -2639,8 +2639,8 @@ bool prepare_mmio_access(MemoryRegion *mr)
>   {
>       bool release_lock = false;
>   
> -    if (!qemu_mutex_iothread_locked()) {
> -        qemu_mutex_lock_iothread();
> +    if (!qemu_bql_locked()) {
> +        qemu_bql_lock();
>           release_lock = true;
>       }
>       if (mr->flush_coalesced_mmio) {
> @@ -2721,7 +2721,7 @@ static MemTxResult flatview_write_continue(FlatView *fv, hwaddr addr,
>           }
>   
>           if (release_lock) {
> -            qemu_mutex_unlock_iothread();
> +            qemu_bql_unlock();
>               release_lock = false;
>           }
>   
> @@ -2799,7 +2799,7 @@ MemTxResult flatview_read_continue(FlatView *fv, hwaddr addr,
>           }
>   
>           if (release_lock) {
> -            qemu_mutex_unlock_iothread();
> +            qemu_bql_unlock();
>               release_lock = false;
>           }
>   
> diff --git a/system/runstate.c b/system/runstate.c
> index ea9d6c2a32..5718e6827c 100644
> --- a/system/runstate.c
> +++ b/system/runstate.c
> @@ -810,7 +810,7 @@ void qemu_init_subsystems(void)
>   
>       qemu_init_cpu_list();
>       qemu_init_cpu_loop();
> -    qemu_mutex_lock_iothread();
> +    qemu_bql_lock();
>   
>       atexit(qemu_run_exit_notifiers);
>   
> diff --git a/system/watchpoint.c b/system/watchpoint.c
> index ba5ad13352..d9cc71dd33 100644
> --- a/system/watchpoint.c
> +++ b/system/watchpoint.c
> @@ -155,9 +155,9 @@ void cpu_check_watchpoint(CPUState *cpu, vaddr addr, vaddr len,
>            * Now raise the debug interrupt so that it will
>            * trigger after the current instruction.
>            */
> -        qemu_mutex_lock_iothread();
> +        qemu_bql_lock();
>           cpu_interrupt(cpu, CPU_INTERRUPT_DEBUG);
> -        qemu_mutex_unlock_iothread();
> +        qemu_bql_unlock();
>           return;
>       }
>   
> diff --git a/target/arm/arm-powerctl.c b/target/arm/arm-powerctl.c
> index c078849403..aec104834d 100644
> --- a/target/arm/arm-powerctl.c
> +++ b/target/arm/arm-powerctl.c
> @@ -88,7 +88,7 @@ static void arm_set_cpu_on_async_work(CPUState *target_cpu_state,
>       g_free(info);
>   
>       /* Finally set the power status */
> -    assert(qemu_mutex_iothread_locked());
> +    assert(qemu_bql_locked());
>       target_cpu->power_state = PSCI_ON;
>   }
>   
> @@ -99,7 +99,7 @@ int arm_set_cpu_on(uint64_t cpuid, uint64_t entry, uint64_t context_id,
>       ARMCPU *target_cpu;
>       struct CpuOnInfo *info;
>   
> -    assert(qemu_mutex_iothread_locked());
> +    assert(qemu_bql_locked());
>   
>       DPRINTF("cpu %" PRId64 " (EL %d, %s) @ 0x%" PRIx64 " with R0 = 0x%" PRIx64
>               "\n", cpuid, target_el, target_aa64 ? "aarch64" : "aarch32", entry,
> @@ -196,7 +196,7 @@ static void arm_set_cpu_on_and_reset_async_work(CPUState *target_cpu_state,
>       target_cpu_state->halted = 0;
>   
>       /* Finally set the power status */
> -    assert(qemu_mutex_iothread_locked());
> +    assert(qemu_bql_locked());
>       target_cpu->power_state = PSCI_ON;
>   }
>   
> @@ -205,7 +205,7 @@ int arm_set_cpu_on_and_reset(uint64_t cpuid)
>       CPUState *target_cpu_state;
>       ARMCPU *target_cpu;
>   
> -    assert(qemu_mutex_iothread_locked());
> +    assert(qemu_bql_locked());
>   
>       /* Retrieve the cpu we are powering up */
>       target_cpu_state = arm_get_cpu_by_id(cpuid);
> @@ -247,7 +247,7 @@ static void arm_set_cpu_off_async_work(CPUState *target_cpu_state,
>   {
>       ARMCPU *target_cpu = ARM_CPU(target_cpu_state);
>   
> -    assert(qemu_mutex_iothread_locked());
> +    assert(qemu_bql_locked());
>       target_cpu->power_state = PSCI_OFF;
>       target_cpu_state->halted = 1;
>       target_cpu_state->exception_index = EXCP_HLT;
> @@ -258,7 +258,7 @@ int arm_set_cpu_off(uint64_t cpuid)
>       CPUState *target_cpu_state;
>       ARMCPU *target_cpu;
>   
> -    assert(qemu_mutex_iothread_locked());
> +    assert(qemu_bql_locked());
>   
>       DPRINTF("cpu %" PRId64 "\n", cpuid);
>   
> @@ -294,7 +294,7 @@ int arm_reset_cpu(uint64_t cpuid)
>       CPUState *target_cpu_state;
>       ARMCPU *target_cpu;
>   
> -    assert(qemu_mutex_iothread_locked());
> +    assert(qemu_bql_locked());
>   
>       DPRINTF("cpu %" PRId64 "\n", cpuid);
>   
> diff --git a/target/arm/helper.c b/target/arm/helper.c
> index 2746d3fdac..f472043986 100644
> --- a/target/arm/helper.c
> +++ b/target/arm/helper.c
> @@ -5831,7 +5831,7 @@ static void do_hcr_write(CPUARMState *env, uint64_t value, uint64_t valid_mask)
>        * VFIQ are masked unless running at EL0 or EL1, and HCR
>        * can only be written at EL2.
>        */
> -    g_assert(qemu_mutex_iothread_locked());
> +    g_assert(qemu_bql_locked());
>       arm_cpu_update_virq(cpu);
>       arm_cpu_update_vfiq(cpu);
>       arm_cpu_update_vserr(cpu);
> @@ -11344,7 +11344,7 @@ void arm_cpu_do_interrupt(CPUState *cs)
>        * BQL needs to be held for any modification of
>        * cs->interrupt_request.
>        */
> -    g_assert(qemu_mutex_iothread_locked());
> +    g_assert(qemu_bql_locked());
>   
>       arm_call_pre_el_change_hook(cpu);
>   
> diff --git a/target/arm/hvf/hvf.c b/target/arm/hvf/hvf.c
> index 757e13b0f9..017fd13c5d 100644
> --- a/target/arm/hvf/hvf.c
> +++ b/target/arm/hvf/hvf.c
> @@ -1718,9 +1718,9 @@ static void hvf_wait_for_ipi(CPUState *cpu, struct timespec *ts)
>        * sleeping.
>        */
>       qatomic_set_mb(&cpu->thread_kicked, false);
> -    qemu_mutex_unlock_iothread();
> +    qemu_bql_unlock();
>       pselect(0, 0, 0, 0, ts, &cpu->accel->unblock_ipi_mask);
> -    qemu_mutex_lock_iothread();
> +    qemu_bql_lock();
>   }
>   
>   static void hvf_wfi(CPUState *cpu)
> @@ -1821,7 +1821,7 @@ int hvf_vcpu_exec(CPUState *cpu)
>   
>       flush_cpu_state(cpu);
>   
> -    qemu_mutex_unlock_iothread();
> +    qemu_bql_unlock();
>       assert_hvf_ok(hv_vcpu_run(cpu->accel->fd));
>   
>       /* handle VMEXIT */
> @@ -1830,7 +1830,7 @@ int hvf_vcpu_exec(CPUState *cpu)
>       uint32_t ec = syn_get_ec(syndrome);
>   
>       ret = 0;
> -    qemu_mutex_lock_iothread();
> +    qemu_bql_lock();
>       switch (exit_reason) {
>       case HV_EXIT_REASON_EXCEPTION:
>           /* This is the main one, handle below. */
> diff --git a/target/arm/kvm.c b/target/arm/kvm.c
> index 7903e2ddde..431b82e509 100644
> --- a/target/arm/kvm.c
> +++ b/target/arm/kvm.c
> @@ -833,7 +833,7 @@ MemTxAttrs kvm_arch_post_run(CPUState *cs, struct kvm_run *run)
>       if (run->s.regs.device_irq_level != cpu->device_irq_level) {
>           switched_level = cpu->device_irq_level ^ run->s.regs.device_irq_level;
>   
> -        qemu_mutex_lock_iothread();
> +        qemu_bql_lock();
>   
>           if (switched_level & KVM_ARM_DEV_EL1_VTIMER) {
>               qemu_set_irq(cpu->gt_timer_outputs[GTIMER_VIRT],
> @@ -862,7 +862,7 @@ MemTxAttrs kvm_arch_post_run(CPUState *cs, struct kvm_run *run)
>   
>           /* We also mark unknown levels as processed to not waste cycles */
>           cpu->device_irq_level = run->s.regs.device_irq_level;
> -        qemu_mutex_unlock_iothread();
> +        qemu_bql_unlock();
>       }
>   
>       return MEMTXATTRS_UNSPECIFIED;
> diff --git a/target/arm/kvm64.c b/target/arm/kvm64.c
> index 3c175c93a7..282dc5920e 100644
> --- a/target/arm/kvm64.c
> +++ b/target/arm/kvm64.c
> @@ -1233,9 +1233,9 @@ bool kvm_arm_handle_debug(CPUState *cs, struct kvm_debug_exit_arch *debug_exit)
>       env->exception.syndrome = debug_exit->hsr;
>       env->exception.vaddress = debug_exit->far;
>       env->exception.target_el = 1;
> -    qemu_mutex_lock_iothread();
> +    qemu_bql_lock();
>       arm_cpu_do_interrupt(cs);
> -    qemu_mutex_unlock_iothread();
> +    qemu_bql_unlock();
>   
>       return false;
>   }
> diff --git a/target/arm/ptw.c b/target/arm/ptw.c
> index 1762b058ae..e3cc0a7ab8 100644
> --- a/target/arm/ptw.c
> +++ b/target/arm/ptw.c
> @@ -772,9 +772,9 @@ static uint64_t arm_casq_ptw(CPUARMState *env, uint64_t old_val,
>   #if !TCG_OVERSIZED_GUEST
>   # error "Unexpected configuration"
>   #endif
> -    bool locked = qemu_mutex_iothread_locked();
> +    bool locked = qemu_bql_locked();
>       if (!locked) {
> -       qemu_mutex_lock_iothread();
> +        qemu_bql_lock();
>       }
>       if (ptw->out_be) {
>           cur_val = ldq_be_p(host);
> @@ -788,7 +788,7 @@ static uint64_t arm_casq_ptw(CPUARMState *env, uint64_t old_val,
>           }
>       }
>       if (!locked) {
> -        qemu_mutex_unlock_iothread();
> +        qemu_bql_unlock();
>       }
>   #endif
>   
> diff --git a/target/arm/tcg/helper-a64.c b/target/arm/tcg/helper-a64.c
> index 8ad84623d3..22d453e6e0 100644
> --- a/target/arm/tcg/helper-a64.c
> +++ b/target/arm/tcg/helper-a64.c
> @@ -809,9 +809,9 @@ void HELPER(exception_return)(CPUARMState *env, uint64_t new_pc)
>           goto illegal_return;
>       }
>   
> -    qemu_mutex_lock_iothread();
> +    qemu_bql_lock();
>       arm_call_pre_el_change_hook(env_archcpu(env));
> -    qemu_mutex_unlock_iothread();
> +    qemu_bql_unlock();
>   
>       if (!return_to_aa64) {
>           env->aarch64 = false;
> @@ -876,9 +876,9 @@ void HELPER(exception_return)(CPUARMState *env, uint64_t new_pc)
>        */
>       aarch64_sve_change_el(env, cur_el, new_el, return_to_aa64);
>   
> -    qemu_mutex_lock_iothread();
> +    qemu_bql_lock();
>       arm_call_el_change_hook(env_archcpu(env));
> -    qemu_mutex_unlock_iothread();
> +    qemu_bql_unlock();
>   
>       return;
>   
> diff --git a/target/arm/tcg/m_helper.c b/target/arm/tcg/m_helper.c
> index a26adb75aa..5f38b9a4a1 100644
> --- a/target/arm/tcg/m_helper.c
> +++ b/target/arm/tcg/m_helper.c
> @@ -374,7 +374,7 @@ void HELPER(v7m_preserve_fp_state)(CPUARMState *env)
>       bool take_exception;
>   
>       /* Take the iothread lock as we are going to touch the NVIC */
> -    qemu_mutex_lock_iothread();
> +    qemu_bql_lock();
>   
>       /* Check the background context had access to the FPU */
>       if (!v7m_cpacr_pass(env, is_secure, is_priv)) {
> @@ -428,7 +428,7 @@ void HELPER(v7m_preserve_fp_state)(CPUARMState *env)
>       take_exception = !stacked_ok &&
>           armv7m_nvic_can_take_pending_exception(env->nvic);
>   
> -    qemu_mutex_unlock_iothread();
> +    qemu_bql_unlock();
>   
>       if (take_exception) {
>           raise_exception_ra(env, EXCP_LAZYFP, 0, 1, GETPC());
> diff --git a/target/arm/tcg/op_helper.c b/target/arm/tcg/op_helper.c
> index ea08936a85..46a14aac52 100644
> --- a/target/arm/tcg/op_helper.c
> +++ b/target/arm/tcg/op_helper.c
> @@ -427,9 +427,9 @@ void HELPER(cpsr_write_eret)(CPUARMState *env, uint32_t val)
>   {
>       uint32_t mask;
>   
> -    qemu_mutex_lock_iothread();
> +    qemu_bql_lock();
>       arm_call_pre_el_change_hook(env_archcpu(env));
> -    qemu_mutex_unlock_iothread();
> +    qemu_bql_unlock();
>   
>       mask = aarch32_cpsr_valid_mask(env->features, &env_archcpu(env)->isar);
>       cpsr_write(env, val, mask, CPSRWriteExceptionReturn);
> @@ -442,9 +442,9 @@ void HELPER(cpsr_write_eret)(CPUARMState *env, uint32_t val)
>       env->regs[15] &= (env->thumb ? ~1 : ~3);
>       arm_rebuild_hflags(env);
>   
> -    qemu_mutex_lock_iothread();
> +    qemu_bql_lock();
>       arm_call_el_change_hook(env_archcpu(env));
> -    qemu_mutex_unlock_iothread();
> +    qemu_bql_unlock();
>   }
>   
>   /* Access to user mode registers from privileged modes.  */
> @@ -803,9 +803,9 @@ void HELPER(set_cp_reg)(CPUARMState *env, const void *rip, uint32_t value)
>       const ARMCPRegInfo *ri = rip;
>   
>       if (ri->type & ARM_CP_IO) {
> -        qemu_mutex_lock_iothread();
> +        qemu_bql_lock();
>           ri->writefn(env, ri, value);
> -        qemu_mutex_unlock_iothread();
> +        qemu_bql_unlock();
>       } else {
>           ri->writefn(env, ri, value);
>       }
> @@ -817,9 +817,9 @@ uint32_t HELPER(get_cp_reg)(CPUARMState *env, const void *rip)
>       uint32_t res;
>   
>       if (ri->type & ARM_CP_IO) {
> -        qemu_mutex_lock_iothread();
> +        qemu_bql_lock();
>           res = ri->readfn(env, ri);
> -        qemu_mutex_unlock_iothread();
> +        qemu_bql_unlock();
>       } else {
>           res = ri->readfn(env, ri);
>       }
> @@ -832,9 +832,9 @@ void HELPER(set_cp_reg64)(CPUARMState *env, const void *rip, uint64_t value)
>       const ARMCPRegInfo *ri = rip;
>   
>       if (ri->type & ARM_CP_IO) {
> -        qemu_mutex_lock_iothread();
> +        qemu_bql_lock();
>           ri->writefn(env, ri, value);
> -        qemu_mutex_unlock_iothread();
> +        qemu_bql_unlock();
>       } else {
>           ri->writefn(env, ri, value);
>       }
> @@ -846,9 +846,9 @@ uint64_t HELPER(get_cp_reg64)(CPUARMState *env, const void *rip)
>       uint64_t res;
>   
>       if (ri->type & ARM_CP_IO) {
> -        qemu_mutex_lock_iothread();
> +        qemu_bql_lock();
>           res = ri->readfn(env, ri);
> -        qemu_mutex_unlock_iothread();
> +        qemu_bql_unlock();
>       } else {
>           res = ri->readfn(env, ri);
>       }
> diff --git a/target/arm/tcg/psci.c b/target/arm/tcg/psci.c
> index 6c1239bb96..51af10db99 100644
> --- a/target/arm/tcg/psci.c
> +++ b/target/arm/tcg/psci.c
> @@ -107,7 +107,7 @@ void arm_handle_psci_call(ARMCPU *cpu)
>               }
>               target_cpu = ARM_CPU(target_cpu_state);
>   
> -            g_assert(qemu_mutex_iothread_locked());
> +            g_assert(qemu_bql_locked());
>               ret = target_cpu->power_state;
>               break;
>           default:
> diff --git a/target/hppa/int_helper.c b/target/hppa/int_helper.c
> index 98e9d688f6..9ef8cf7ff4 100644
> --- a/target/hppa/int_helper.c
> +++ b/target/hppa/int_helper.c
> @@ -84,17 +84,17 @@ void hppa_cpu_alarm_timer(void *opaque)
>   void HELPER(write_eirr)(CPUHPPAState *env, target_ulong val)
>   {
>       env->cr[CR_EIRR] &= ~val;
> -    qemu_mutex_lock_iothread();
> +    qemu_bql_lock();
>       eval_interrupt(env_archcpu(env));
> -    qemu_mutex_unlock_iothread();
> +    qemu_bql_unlock();
>   }
>   
>   void HELPER(write_eiem)(CPUHPPAState *env, target_ulong val)
>   {
>       env->cr[CR_EIEM] = val;
> -    qemu_mutex_lock_iothread();
> +    qemu_bql_lock();
>       eval_interrupt(env_archcpu(env));
> -    qemu_mutex_unlock_iothread();
> +    qemu_bql_unlock();
>   }
>   
>   void hppa_cpu_do_interrupt(CPUState *cs)
> diff --git a/target/i386/hvf/hvf.c b/target/i386/hvf/hvf.c
> index 20b9ca3ef5..2cc8b115f7 100644
> --- a/target/i386/hvf/hvf.c
> +++ b/target/i386/hvf/hvf.c
> @@ -429,9 +429,9 @@ int hvf_vcpu_exec(CPUState *cpu)
>           }
>           vmx_update_tpr(cpu);
>   
> -        qemu_mutex_unlock_iothread();
> +        qemu_bql_unlock();
>           if (!cpu_is_bsp(X86_CPU(cpu)) && cpu->halted) {
> -            qemu_mutex_lock_iothread();
> +            qemu_bql_lock();
>               return EXCP_HLT;
>           }
>   
> @@ -450,7 +450,7 @@ int hvf_vcpu_exec(CPUState *cpu)
>           rip = rreg(cpu->accel->fd, HV_X86_RIP);
>           env->eflags = rreg(cpu->accel->fd, HV_X86_RFLAGS);
>   
> -        qemu_mutex_lock_iothread();
> +        qemu_bql_lock();
>   
>           update_apic_tpr(cpu);
>           current_cpu = cpu;
> diff --git a/target/i386/kvm/hyperv.c b/target/i386/kvm/hyperv.c
> index e3ac978648..dcad09f6c9 100644
> --- a/target/i386/kvm/hyperv.c
> +++ b/target/i386/kvm/hyperv.c
> @@ -45,9 +45,9 @@ void hyperv_x86_synic_update(X86CPU *cpu)
>   
>   static void async_synic_update(CPUState *cs, run_on_cpu_data data)
>   {
> -    qemu_mutex_lock_iothread();
> +    qemu_bql_lock();
>       hyperv_x86_synic_update(X86_CPU(cs));
> -    qemu_mutex_unlock_iothread();
> +    qemu_bql_unlock();
>   }
>   
>   int kvm_hv_handle_exit(X86CPU *cpu, struct kvm_hyperv_exit *exit)
> diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
> index 11b8177eff..084f5e6b8b 100644
> --- a/target/i386/kvm/kvm.c
> +++ b/target/i386/kvm/kvm.c
> @@ -4705,9 +4705,9 @@ void kvm_arch_pre_run(CPUState *cpu, struct kvm_run *run)
>       /* Inject NMI */
>       if (cpu->interrupt_request & (CPU_INTERRUPT_NMI | CPU_INTERRUPT_SMI)) {
>           if (cpu->interrupt_request & CPU_INTERRUPT_NMI) {
> -            qemu_mutex_lock_iothread();
> +            qemu_bql_lock();
>               cpu->interrupt_request &= ~CPU_INTERRUPT_NMI;
> -            qemu_mutex_unlock_iothread();
> +            qemu_bql_unlock();
>               DPRINTF("injected NMI\n");
>               ret = kvm_vcpu_ioctl(cpu, KVM_NMI);
>               if (ret < 0) {
> @@ -4716,9 +4716,9 @@ void kvm_arch_pre_run(CPUState *cpu, struct kvm_run *run)
>               }
>           }
>           if (cpu->interrupt_request & CPU_INTERRUPT_SMI) {
> -            qemu_mutex_lock_iothread();
> +            qemu_bql_lock();
>               cpu->interrupt_request &= ~CPU_INTERRUPT_SMI;
> -            qemu_mutex_unlock_iothread();
> +            qemu_bql_unlock();
>               DPRINTF("injected SMI\n");
>               ret = kvm_vcpu_ioctl(cpu, KVM_SMI);
>               if (ret < 0) {
> @@ -4729,7 +4729,7 @@ void kvm_arch_pre_run(CPUState *cpu, struct kvm_run *run)
>       }
>   
>       if (!kvm_pic_in_kernel()) {
> -        qemu_mutex_lock_iothread();
> +        qemu_bql_lock();
>       }
>   
>       /* Force the VCPU out of its inner loop to process any INIT requests
> @@ -4782,7 +4782,7 @@ void kvm_arch_pre_run(CPUState *cpu, struct kvm_run *run)
>           DPRINTF("setting tpr\n");
>           run->cr8 = cpu_get_apic_tpr(x86_cpu->apic_state);
>   
> -        qemu_mutex_unlock_iothread();
> +        qemu_bql_unlock();
>       }
>   }
>   
> @@ -4830,12 +4830,12 @@ MemTxAttrs kvm_arch_post_run(CPUState *cpu, struct kvm_run *run)
>       /* We need to protect the apic state against concurrent accesses from
>        * different threads in case the userspace irqchip is used. */
>       if (!kvm_irqchip_in_kernel()) {
> -        qemu_mutex_lock_iothread();
> +        qemu_bql_lock();
>       }
>       cpu_set_apic_tpr(x86_cpu->apic_state, run->cr8);
>       cpu_set_apic_base(x86_cpu->apic_state, run->apic_base);
>       if (!kvm_irqchip_in_kernel()) {
> -        qemu_mutex_unlock_iothread();
> +        qemu_bql_unlock();
>       }
>       return cpu_get_mem_attrs(env);
>   }
> @@ -5269,17 +5269,17 @@ int kvm_arch_handle_exit(CPUState *cs, struct kvm_run *run)
>       switch (run->exit_reason) {
>       case KVM_EXIT_HLT:
>           DPRINTF("handle_hlt\n");
> -        qemu_mutex_lock_iothread();
> +        qemu_bql_lock();
>           ret = kvm_handle_halt(cpu);
> -        qemu_mutex_unlock_iothread();
> +        qemu_bql_unlock();
>           break;
>       case KVM_EXIT_SET_TPR:
>           ret = 0;
>           break;
>       case KVM_EXIT_TPR_ACCESS:
> -        qemu_mutex_lock_iothread();
> +        qemu_bql_lock();
>           ret = kvm_handle_tpr_access(cpu);
> -        qemu_mutex_unlock_iothread();
> +        qemu_bql_unlock();
>           break;
>       case KVM_EXIT_FAIL_ENTRY:
>           code = run->fail_entry.hardware_entry_failure_reason;
> @@ -5305,9 +5305,9 @@ int kvm_arch_handle_exit(CPUState *cs, struct kvm_run *run)
>           break;
>       case KVM_EXIT_DEBUG:
>           DPRINTF("kvm_exit_debug\n");
> -        qemu_mutex_lock_iothread();
> +        qemu_bql_lock();
>           ret = kvm_handle_debug(cpu, &run->debug.arch);
> -        qemu_mutex_unlock_iothread();
> +        qemu_bql_unlock();
>           break;
>       case KVM_EXIT_HYPERV:
>           ret = kvm_hv_handle_exit(cpu, &run->hyperv);
> diff --git a/target/i386/kvm/xen-emu.c b/target/i386/kvm/xen-emu.c
> index c0631f9cf4..f79f5d270f 100644
> --- a/target/i386/kvm/xen-emu.c
> +++ b/target/i386/kvm/xen-emu.c
> @@ -403,7 +403,7 @@ void kvm_xen_maybe_deassert_callback(CPUState *cs)
>   
>       /* If the evtchn_upcall_pending flag is cleared, turn the GSI off. */
>       if (!vi->evtchn_upcall_pending) {
> -        qemu_mutex_lock_iothread();
> +        qemu_bql_lock();
>           /*
>            * Check again now we have the lock, because it may have been
>            * asserted in the interim. And we don't want to take the lock
> @@ -413,7 +413,7 @@ void kvm_xen_maybe_deassert_callback(CPUState *cs)
>               X86_CPU(cs)->env.xen_callback_asserted = false;
>               xen_evtchn_set_callback_level(0);
>           }
> -        qemu_mutex_unlock_iothread();
> +        qemu_bql_unlock();
>       }
>   }
>   
> @@ -773,9 +773,9 @@ static bool handle_set_param(struct kvm_xen_exit *exit, X86CPU *cpu,
>   
>       switch (hp.index) {
>       case HVM_PARAM_CALLBACK_IRQ:
> -        qemu_mutex_lock_iothread();
> +        qemu_bql_lock();
>           err = xen_evtchn_set_callback_param(hp.value);
> -        qemu_mutex_unlock_iothread();
> +        qemu_bql_unlock();
>           xen_set_long_mode(exit->u.hcall.longmode);
>           break;
>       default:
> @@ -1408,7 +1408,7 @@ int kvm_xen_soft_reset(void)
>       CPUState *cpu;
>       int err;
>   
> -    assert(qemu_mutex_iothread_locked());
> +    assert(qemu_bql_locked());
>   
>       trace_kvm_xen_soft_reset();
>   
> @@ -1481,9 +1481,9 @@ static int schedop_shutdown(CPUState *cs, uint64_t arg)
>           break;
>   
>       case SHUTDOWN_soft_reset:
> -        qemu_mutex_lock_iothread();
> +        qemu_bql_lock();
>           ret = kvm_xen_soft_reset();
> -        qemu_mutex_unlock_iothread();
> +        qemu_bql_unlock();
>           break;
>   
>       default:
> diff --git a/target/i386/nvmm/nvmm-accel-ops.c b/target/i386/nvmm/nvmm-accel-ops.c
> index 6c46101ac1..387ccfcce5 100644
> --- a/target/i386/nvmm/nvmm-accel-ops.c
> +++ b/target/i386/nvmm/nvmm-accel-ops.c
> @@ -25,7 +25,7 @@ static void *qemu_nvmm_cpu_thread_fn(void *arg)
>   
>       rcu_register_thread();
>   
> -    qemu_mutex_lock_iothread();
> +    qemu_bql_lock();
>       qemu_thread_get_self(cpu->thread);
>       cpu->thread_id = qemu_get_thread_id();
>       current_cpu = cpu;
> @@ -55,7 +55,7 @@ static void *qemu_nvmm_cpu_thread_fn(void *arg)
>   
>       nvmm_destroy_vcpu(cpu);
>       cpu_thread_signal_destroyed(cpu);
> -    qemu_mutex_unlock_iothread();
> +    qemu_bql_unlock();
>       rcu_unregister_thread();
>       return NULL;
>   }
> diff --git a/target/i386/nvmm/nvmm-all.c b/target/i386/nvmm/nvmm-all.c
> index 7d752bc5e0..9fa5b2e34a 100644
> --- a/target/i386/nvmm/nvmm-all.c
> +++ b/target/i386/nvmm/nvmm-all.c
> @@ -399,7 +399,7 @@ nvmm_vcpu_pre_run(CPUState *cpu)
>       uint8_t tpr;
>       int ret;
>   
> -    qemu_mutex_lock_iothread();
> +    qemu_bql_lock();
>   
>       tpr = cpu_get_apic_tpr(x86_cpu->apic_state);
>       if (tpr != qcpu->tpr) {
> @@ -462,7 +462,7 @@ nvmm_vcpu_pre_run(CPUState *cpu)
>           }
>       }
>   
> -    qemu_mutex_unlock_iothread();
> +    qemu_bql_unlock();
>   }
>   
>   /*
> @@ -485,9 +485,9 @@ nvmm_vcpu_post_run(CPUState *cpu, struct nvmm_vcpu_exit *exit)
>       tpr = exit->exitstate.cr8;
>       if (qcpu->tpr != tpr) {
>           qcpu->tpr = tpr;
> -        qemu_mutex_lock_iothread();
> +        qemu_bql_lock();
>           cpu_set_apic_tpr(x86_cpu->apic_state, qcpu->tpr);
> -        qemu_mutex_unlock_iothread();
> +        qemu_bql_unlock();
>       }
>   }
>   
> @@ -648,7 +648,7 @@ nvmm_handle_halted(struct nvmm_machine *mach, CPUState *cpu,
>       CPUX86State *env = cpu_env(cpu);
>       int ret = 0;
>   
> -    qemu_mutex_lock_iothread();
> +    qemu_bql_lock();
>   
>       if (!((cpu->interrupt_request & CPU_INTERRUPT_HARD) &&
>             (env->eflags & IF_MASK)) &&
> @@ -658,7 +658,7 @@ nvmm_handle_halted(struct nvmm_machine *mach, CPUState *cpu,
>           ret = 1;
>       }
>   
> -    qemu_mutex_unlock_iothread();
> +    qemu_bql_unlock();
>   
>       return ret;
>   }
> @@ -721,7 +721,7 @@ nvmm_vcpu_loop(CPUState *cpu)
>           return 0;
>       }
>   
> -    qemu_mutex_unlock_iothread();
> +    qemu_bql_unlock();
>       cpu_exec_start(cpu);
>   
>       /*
> @@ -806,16 +806,16 @@ nvmm_vcpu_loop(CPUState *cpu)
>               error_report("NVMM: Unexpected VM exit code 0x%lx [hw=0x%lx]",
>                   exit->reason, exit->u.inv.hwcode);
>               nvmm_get_registers(cpu);
> -            qemu_mutex_lock_iothread();
> +            qemu_bql_lock();
>               qemu_system_guest_panicked(cpu_get_crash_info(cpu));
> -            qemu_mutex_unlock_iothread();
> +            qemu_bql_unlock();
>               ret = -1;
>               break;
>           }
>       } while (ret == 0);
>   
>       cpu_exec_end(cpu);
> -    qemu_mutex_lock_iothread();
> +    qemu_bql_lock();
>   
>       qatomic_set(&cpu->exit_request, false);
>   
> diff --git a/target/i386/tcg/sysemu/fpu_helper.c b/target/i386/tcg/sysemu/fpu_helper.c
> index 93506cdd94..4960e97ebc 100644
> --- a/target/i386/tcg/sysemu/fpu_helper.c
> +++ b/target/i386/tcg/sysemu/fpu_helper.c
> @@ -32,9 +32,9 @@ void x86_register_ferr_irq(qemu_irq irq)
>   void fpu_check_raise_ferr_irq(CPUX86State *env)
>   {
>       if (ferr_irq && !(env->hflags2 & HF2_IGNNE_MASK)) {
> -        qemu_mutex_lock_iothread();
> +        qemu_bql_lock();
>           qemu_irq_raise(ferr_irq);
> -        qemu_mutex_unlock_iothread();
> +        qemu_bql_unlock();
>           return;
>       }
>   }
> @@ -49,7 +49,7 @@ void cpu_set_ignne(void)
>   {
>       CPUX86State *env = &X86_CPU(first_cpu)->env;
>   
> -    assert(qemu_mutex_iothread_locked());
> +    assert(qemu_bql_locked());
>   
>       env->hflags2 |= HF2_IGNNE_MASK;
>       /*
> diff --git a/target/i386/tcg/sysemu/misc_helper.c b/target/i386/tcg/sysemu/misc_helper.c
> index e1528b7f80..e859879f4f 100644
> --- a/target/i386/tcg/sysemu/misc_helper.c
> +++ b/target/i386/tcg/sysemu/misc_helper.c
> @@ -118,9 +118,9 @@ void helper_write_crN(CPUX86State *env, int reg, target_ulong t0)
>           break;
>       case 8:
>           if (!(env->hflags2 & HF2_VINTR_MASK)) {
> -            qemu_mutex_lock_iothread();
> +            qemu_bql_lock();
>               cpu_set_apic_tpr(env_archcpu(env)->apic_state, t0);
> -            qemu_mutex_unlock_iothread();
> +            qemu_bql_unlock();
>           }
>           env->int_ctl = (env->int_ctl & ~V_TPR_MASK) | (t0 & V_TPR_MASK);
>   
> diff --git a/target/i386/whpx/whpx-accel-ops.c b/target/i386/whpx/whpx-accel-ops.c
> index 67cad86720..1f29346a88 100644
> --- a/target/i386/whpx/whpx-accel-ops.c
> +++ b/target/i386/whpx/whpx-accel-ops.c
> @@ -25,7 +25,7 @@ static void *whpx_cpu_thread_fn(void *arg)
>   
>       rcu_register_thread();
>   
> -    qemu_mutex_lock_iothread();
> +    qemu_bql_lock();
>       qemu_thread_get_self(cpu->thread);
>       cpu->thread_id = qemu_get_thread_id();
>       current_cpu = cpu;
> @@ -55,7 +55,7 @@ static void *whpx_cpu_thread_fn(void *arg)
>   
>       whpx_destroy_vcpu(cpu);
>       cpu_thread_signal_destroyed(cpu);
> -    qemu_mutex_unlock_iothread();
> +    qemu_bql_unlock();
>       rcu_unregister_thread();
>       return NULL;
>   }
> diff --git a/target/i386/whpx/whpx-all.c b/target/i386/whpx/whpx-all.c
> index d29ba916a0..50057b22ee 100644
> --- a/target/i386/whpx/whpx-all.c
> +++ b/target/i386/whpx/whpx-all.c
> @@ -1324,7 +1324,7 @@ static int whpx_first_vcpu_starting(CPUState *cpu)
>       struct whpx_state *whpx = &whpx_global;
>       HRESULT hr;
>   
> -    g_assert(qemu_mutex_iothread_locked());
> +    g_assert(qemu_bql_locked());
>   
>       if (!QTAILQ_EMPTY(&cpu->breakpoints) ||
>               (whpx->breakpoints.breakpoints &&
> @@ -1442,7 +1442,7 @@ static int whpx_handle_halt(CPUState *cpu)
>       CPUX86State *env = cpu_env(cpu);
>       int ret = 0;
>   
> -    qemu_mutex_lock_iothread();
> +    qemu_bql_lock();
>       if (!((cpu->interrupt_request & CPU_INTERRUPT_HARD) &&
>             (env->eflags & IF_MASK)) &&
>           !(cpu->interrupt_request & CPU_INTERRUPT_NMI)) {
> @@ -1450,7 +1450,7 @@ static int whpx_handle_halt(CPUState *cpu)
>           cpu->halted = true;
>           ret = 1;
>       }
> -    qemu_mutex_unlock_iothread();
> +    qemu_bql_unlock();
>   
>       return ret;
>   }
> @@ -1472,7 +1472,7 @@ static void whpx_vcpu_pre_run(CPUState *cpu)
>       memset(&new_int, 0, sizeof(new_int));
>       memset(reg_values, 0, sizeof(reg_values));
>   
> -    qemu_mutex_lock_iothread();
> +    qemu_bql_lock();
>   
>       /* Inject NMI */
>       if (!vcpu->interruption_pending &&
> @@ -1563,7 +1563,7 @@ static void whpx_vcpu_pre_run(CPUState *cpu)
>           reg_count += 1;
>       }
>   
> -    qemu_mutex_unlock_iothread();
> +    qemu_bql_unlock();
>       vcpu->ready_for_pic_interrupt = false;
>   
>       if (reg_count) {
> @@ -1590,9 +1590,9 @@ static void whpx_vcpu_post_run(CPUState *cpu)
>       uint64_t tpr = vcpu->exit_ctx.VpContext.Cr8;
>       if (vcpu->tpr != tpr) {
>           vcpu->tpr = tpr;
> -        qemu_mutex_lock_iothread();
> +        qemu_bql_lock();
>           cpu_set_apic_tpr(x86_cpu->apic_state, whpx_cr8_to_apic_tpr(vcpu->tpr));
> -        qemu_mutex_unlock_iothread();
> +        qemu_bql_unlock();
>       }
>   
>       vcpu->interruption_pending =
> @@ -1652,7 +1652,7 @@ static int whpx_vcpu_run(CPUState *cpu)
>       WhpxStepMode exclusive_step_mode = WHPX_STEP_NONE;
>       int ret;
>   
> -    g_assert(qemu_mutex_iothread_locked());
> +    g_assert(qemu_bql_locked());
>   
>       if (whpx->running_cpus++ == 0) {
>           /* Insert breakpoints into memory, update exception exit bitmap. */
> @@ -1690,7 +1690,7 @@ static int whpx_vcpu_run(CPUState *cpu)
>           }
>       }
>   
> -    qemu_mutex_unlock_iothread();
> +    qemu_bql_unlock();
>   
>       if (exclusive_step_mode != WHPX_STEP_NONE) {
>           start_exclusive();
> @@ -2028,9 +2028,9 @@ static int whpx_vcpu_run(CPUState *cpu)
>               error_report("WHPX: Unexpected VP exit code %d",
>                            vcpu->exit_ctx.ExitReason);
>               whpx_get_registers(cpu);
> -            qemu_mutex_lock_iothread();
> +            qemu_bql_lock();
>               qemu_system_guest_panicked(cpu_get_crash_info(cpu));
> -            qemu_mutex_unlock_iothread();
> +            qemu_bql_unlock();
>               break;
>           }
>   
> @@ -2055,7 +2055,7 @@ static int whpx_vcpu_run(CPUState *cpu)
>           cpu_exec_end(cpu);
>       }
>   
> -    qemu_mutex_lock_iothread();
> +    qemu_bql_lock();
>       current_cpu = cpu;
>   
>       if (--whpx->running_cpus == 0) {
> diff --git a/target/loongarch/csr_helper.c b/target/loongarch/csr_helper.c
> index 55341551a5..fa3f08335e 100644
> --- a/target/loongarch/csr_helper.c
> +++ b/target/loongarch/csr_helper.c
> @@ -89,9 +89,9 @@ target_ulong helper_csrwr_ticlr(CPULoongArchState *env, target_ulong val)
>       int64_t old_v = 0;
>   
>       if (val & 0x1) {
> -        qemu_mutex_lock_iothread();
> +        qemu_bql_lock();
>           loongarch_cpu_set_irq(cpu, IRQ_TIMER, 0);
> -        qemu_mutex_unlock_iothread();
> +        qemu_bql_unlock();
>       }
>       return old_v;
>   }
> diff --git a/target/mips/kvm.c b/target/mips/kvm.c
> index e22e24ed97..7e2bac9a84 100644
> --- a/target/mips/kvm.c
> +++ b/target/mips/kvm.c
> @@ -138,7 +138,7 @@ void kvm_arch_pre_run(CPUState *cs, struct kvm_run *run)
>       int r;
>       struct kvm_mips_interrupt intr;
>   
> -    qemu_mutex_lock_iothread();
> +    qemu_bql_lock();
>   
>       if ((cs->interrupt_request & CPU_INTERRUPT_HARD) &&
>               cpu_mips_io_interrupts_pending(cpu)) {
> @@ -151,7 +151,7 @@ void kvm_arch_pre_run(CPUState *cs, struct kvm_run *run)
>           }
>       }
>   
> -    qemu_mutex_unlock_iothread();
> +    qemu_bql_unlock();
>   }
>   
>   MemTxAttrs kvm_arch_post_run(CPUState *cs, struct kvm_run *run)
> diff --git a/target/mips/tcg/sysemu/cp0_helper.c b/target/mips/tcg/sysemu/cp0_helper.c
> index d349548743..fe87b72a2c 100644
> --- a/target/mips/tcg/sysemu/cp0_helper.c
> +++ b/target/mips/tcg/sysemu/cp0_helper.c
> @@ -59,9 +59,9 @@ static inline void mips_vpe_wake(MIPSCPU *c)
>        * because there might be other conditions that state that c should
>        * be sleeping.
>        */
> -    qemu_mutex_lock_iothread();
> +    qemu_bql_lock();
>       cpu_interrupt(CPU(c), CPU_INTERRUPT_WAKE);
> -    qemu_mutex_unlock_iothread();
> +    qemu_bql_unlock();
>   }
>   
>   static inline void mips_vpe_sleep(MIPSCPU *cpu)
> diff --git a/target/openrisc/sys_helper.c b/target/openrisc/sys_helper.c
> index 782a5751b7..1e9a55cec1 100644
> --- a/target/openrisc/sys_helper.c
> +++ b/target/openrisc/sys_helper.c
> @@ -160,20 +160,20 @@ void HELPER(mtspr)(CPUOpenRISCState *env, target_ulong spr, target_ulong rb)
>           break;
>       case TO_SPR(9, 0):  /* PICMR */
>           env->picmr = rb;
> -        qemu_mutex_lock_iothread();
> +        qemu_bql_lock();
>           if (env->picsr & env->picmr) {
>               cpu_interrupt(cs, CPU_INTERRUPT_HARD);
>           } else {
>               cpu_reset_interrupt(cs, CPU_INTERRUPT_HARD);
>           }
> -        qemu_mutex_unlock_iothread();
> +        qemu_bql_unlock();
>           break;
>       case TO_SPR(9, 2):  /* PICSR */
>           env->picsr &= ~rb;
>           break;
>       case TO_SPR(10, 0): /* TTMR */
>           {
> -            qemu_mutex_lock_iothread();
> +            qemu_bql_lock();
>               if ((env->ttmr & TTMR_M) ^ (rb & TTMR_M)) {
>                   switch (rb & TTMR_M) {
>                   case TIMER_NONE:
> @@ -198,15 +198,15 @@ void HELPER(mtspr)(CPUOpenRISCState *env, target_ulong spr, target_ulong rb)
>                   cs->interrupt_request &= ~CPU_INTERRUPT_TIMER;
>               }
>               cpu_openrisc_timer_update(cpu);
> -            qemu_mutex_unlock_iothread();
> +            qemu_bql_unlock();
>           }
>           break;
>   
>       case TO_SPR(10, 1): /* TTCR */
> -        qemu_mutex_lock_iothread();
> +        qemu_bql_lock();
>           cpu_openrisc_count_set(cpu, rb);
>           cpu_openrisc_timer_update(cpu);
> -        qemu_mutex_unlock_iothread();
> +        qemu_bql_unlock();
>           break;
>       }
>   #endif
> @@ -347,9 +347,9 @@ target_ulong HELPER(mfspr)(CPUOpenRISCState *env, target_ulong rd,
>           return env->ttmr;
>   
>       case TO_SPR(10, 1): /* TTCR */
> -        qemu_mutex_lock_iothread();
> +        qemu_bql_lock();
>           cpu_openrisc_count_update(cpu);
> -        qemu_mutex_unlock_iothread();
> +        qemu_bql_unlock();
>           return cpu_openrisc_count_get(cpu);
>       }
>   #endif
> diff --git a/target/ppc/excp_helper.c b/target/ppc/excp_helper.c
> index a42743a3e0..0a1c942831 100644
> --- a/target/ppc/excp_helper.c
> +++ b/target/ppc/excp_helper.c
> @@ -3056,7 +3056,7 @@ void helper_msgsnd(target_ulong rb)
>           return;
>       }
>   
> -    qemu_mutex_lock_iothread();
> +    qemu_bql_lock();
>       CPU_FOREACH(cs) {
>           PowerPCCPU *cpu = POWERPC_CPU(cs);
>           CPUPPCState *cenv = &cpu->env;
> @@ -3065,7 +3065,7 @@ void helper_msgsnd(target_ulong rb)
>               ppc_set_irq(cpu, irq, 1);
>           }
>       }
> -    qemu_mutex_unlock_iothread();
> +    qemu_bql_unlock();
>   }
>   
>   /* Server Processor Control */
> @@ -3093,7 +3093,7 @@ static void book3s_msgsnd_common(int pir, int irq)
>   {
>       CPUState *cs;
>   
> -    qemu_mutex_lock_iothread();
> +    qemu_bql_lock();
>       CPU_FOREACH(cs) {
>           PowerPCCPU *cpu = POWERPC_CPU(cs);
>           CPUPPCState *cenv = &cpu->env;
> @@ -3103,7 +3103,7 @@ static void book3s_msgsnd_common(int pir, int irq)
>               ppc_set_irq(cpu, irq, 1);
>           }
>       }
> -    qemu_mutex_unlock_iothread();
> +    qemu_bql_unlock();
>   }
>   
>   void helper_book3s_msgsnd(target_ulong rb)
> @@ -3157,14 +3157,14 @@ void helper_book3s_msgsndp(CPUPPCState *env, target_ulong rb)
>       }
>   
>       /* Does iothread need to be locked for walking CPU list? */
> -    qemu_mutex_lock_iothread();
> +    qemu_bql_lock();
>       THREAD_SIBLING_FOREACH(cs, ccs) {
>           PowerPCCPU *ccpu = POWERPC_CPU(ccs);
>           uint32_t thread_id = ppc_cpu_tir(ccpu);
>   
>           if (ttir == thread_id) {
>               ppc_set_irq(ccpu, PPC_INTERRUPT_DOORBELL, 1);
> -            qemu_mutex_unlock_iothread();
> +            qemu_bql_unlock();
>               return;
>           }
>       }
> diff --git a/target/ppc/kvm.c b/target/ppc/kvm.c
> index 9b1abe2fc4..132834505c 100644
> --- a/target/ppc/kvm.c
> +++ b/target/ppc/kvm.c
> @@ -1656,7 +1656,7 @@ int kvm_arch_handle_exit(CPUState *cs, struct kvm_run *run)
>       CPUPPCState *env = &cpu->env;
>       int ret;
>   
> -    qemu_mutex_lock_iothread();
> +    qemu_bql_lock();
>   
>       switch (run->exit_reason) {
>       case KVM_EXIT_DCR:
> @@ -1715,7 +1715,7 @@ int kvm_arch_handle_exit(CPUState *cs, struct kvm_run *run)
>           break;
>       }
>   
> -    qemu_mutex_unlock_iothread();
> +    qemu_bql_unlock();
>       return ret;
>   }
>   
> diff --git a/target/ppc/misc_helper.c b/target/ppc/misc_helper.c
> index a05bdf78c9..41ef14bf24 100644
> --- a/target/ppc/misc_helper.c
> +++ b/target/ppc/misc_helper.c
> @@ -238,7 +238,7 @@ target_ulong helper_load_dpdes(CPUPPCState *env)
>           return dpdes;
>       }
>   
> -    qemu_mutex_lock_iothread();
> +    qemu_bql_lock();
>       THREAD_SIBLING_FOREACH(cs, ccs) {
>           PowerPCCPU *ccpu = POWERPC_CPU(ccs);
>           CPUPPCState *cenv = &ccpu->env;
> @@ -248,7 +248,7 @@ target_ulong helper_load_dpdes(CPUPPCState *env)
>               dpdes |= (0x1 << thread_id);
>           }
>       }
> -    qemu_mutex_unlock_iothread();
> +    qemu_bql_unlock();
>   
>       return dpdes;
>   }
> @@ -278,14 +278,14 @@ void helper_store_dpdes(CPUPPCState *env, target_ulong val)
>       }
>   
>       /* Does iothread need to be locked for walking CPU list? */
> -    qemu_mutex_lock_iothread();
> +    qemu_bql_lock();
>       THREAD_SIBLING_FOREACH(cs, ccs) {
>           PowerPCCPU *ccpu = POWERPC_CPU(ccs);
>           uint32_t thread_id = ppc_cpu_tir(ccpu);
>   
>           ppc_set_irq(cpu, PPC_INTERRUPT_DOORBELL, val & (0x1 << thread_id));
>       }
> -    qemu_mutex_unlock_iothread();
> +    qemu_bql_unlock();
>   }
>   #endif /* defined(TARGET_PPC64) */
>   
> diff --git a/target/ppc/timebase_helper.c b/target/ppc/timebase_helper.c
> index 08a6b47ee0..4cc0572fad 100644
> --- a/target/ppc/timebase_helper.c
> +++ b/target/ppc/timebase_helper.c
> @@ -173,9 +173,9 @@ target_ulong helper_load_dcr(CPUPPCState *env, target_ulong dcrn)
>       } else {
>           int ret;
>   
> -        qemu_mutex_lock_iothread();
> +        qemu_bql_lock();
>           ret = ppc_dcr_read(env->dcr_env, (uint32_t)dcrn, &val);
> -        qemu_mutex_unlock_iothread();
> +        qemu_bql_unlock();
>           if (unlikely(ret != 0)) {
>               qemu_log_mask(LOG_GUEST_ERROR, "DCR read error %d %03x\n",
>                             (uint32_t)dcrn, (uint32_t)dcrn);
> @@ -196,9 +196,9 @@ void helper_store_dcr(CPUPPCState *env, target_ulong dcrn, target_ulong val)
>                                  POWERPC_EXCP_INVAL_INVAL, GETPC());
>       } else {
>           int ret;
> -        qemu_mutex_lock_iothread();
> +        qemu_bql_lock();
>           ret = ppc_dcr_write(env->dcr_env, (uint32_t)dcrn, (uint32_t)val);
> -        qemu_mutex_unlock_iothread();
> +        qemu_bql_unlock();
>           if (unlikely(ret != 0)) {
>               qemu_log_mask(LOG_GUEST_ERROR, "DCR write error %d %03x\n",
>                             (uint32_t)dcrn, (uint32_t)dcrn);
> diff --git a/target/s390x/kvm/kvm.c b/target/s390x/kvm/kvm.c
> index 33ab3551f4..27533d0401 100644
> --- a/target/s390x/kvm/kvm.c
> +++ b/target/s390x/kvm/kvm.c
> @@ -1923,7 +1923,7 @@ int kvm_arch_handle_exit(CPUState *cs, struct kvm_run *run)
>       S390CPU *cpu = S390_CPU(cs);
>       int ret = 0;
>   
> -    qemu_mutex_lock_iothread();
> +    qemu_bql_lock();
>   
>       kvm_cpu_synchronize_state(cs);
>   
> @@ -1947,7 +1947,7 @@ int kvm_arch_handle_exit(CPUState *cs, struct kvm_run *run)
>               fprintf(stderr, "Unknown KVM exit: %d\n", run->exit_reason);
>               break;
>       }
> -    qemu_mutex_unlock_iothread();
> +    qemu_bql_unlock();
>   
>       if (ret == 0) {
>           ret = EXCP_INTERRUPT;
> diff --git a/target/s390x/tcg/misc_helper.c b/target/s390x/tcg/misc_helper.c
> index 6aa7907438..4be69c5ae8 100644
> --- a/target/s390x/tcg/misc_helper.c
> +++ b/target/s390x/tcg/misc_helper.c
> @@ -101,9 +101,9 @@ uint64_t HELPER(stck)(CPUS390XState *env)
>   /* SCLP service call */
>   uint32_t HELPER(servc)(CPUS390XState *env, uint64_t r1, uint64_t r2)
>   {
> -    qemu_mutex_lock_iothread();
> +    qemu_bql_lock();
>       int r = sclp_service_call(env_archcpu(env), r1, r2);
> -    qemu_mutex_unlock_iothread();
> +    qemu_bql_unlock();
>       if (r < 0) {
>           tcg_s390_program_interrupt(env, -r, GETPC());
>       }
> @@ -117,9 +117,9 @@ void HELPER(diag)(CPUS390XState *env, uint32_t r1, uint32_t r3, uint32_t num)
>       switch (num) {
>       case 0x500:
>           /* KVM hypercall */
> -        qemu_mutex_lock_iothread();
> +        qemu_bql_lock();
>           r = s390_virtio_hypercall(env);
> -        qemu_mutex_unlock_iothread();
> +        qemu_bql_unlock();
>           break;
>       case 0x44:
>           /* yield */
> @@ -127,9 +127,9 @@ void HELPER(diag)(CPUS390XState *env, uint32_t r1, uint32_t r3, uint32_t num)
>           break;
>       case 0x308:
>           /* ipl */
> -        qemu_mutex_lock_iothread();
> +        qemu_bql_lock();
>           handle_diag_308(env, r1, r3, GETPC());
> -        qemu_mutex_unlock_iothread();
> +        qemu_bql_unlock();
>           r = 0;
>           break;
>       case 0x288:
> @@ -185,7 +185,7 @@ static void update_ckc_timer(CPUS390XState *env)
>   
>       /* stop the timer and remove pending CKC IRQs */
>       timer_del(env->tod_timer);
> -    g_assert(qemu_mutex_iothread_locked());
> +    g_assert(qemu_bql_locked());
>       env->pending_int &= ~INTERRUPT_EXT_CLOCK_COMPARATOR;
>   
>       /* the tod has to exceed the ckc, this can never happen if ckc is all 1's */
> @@ -207,9 +207,9 @@ void HELPER(sckc)(CPUS390XState *env, uint64_t ckc)
>   {
>       env->ckc = ckc;
>   
> -    qemu_mutex_lock_iothread();
> +    qemu_bql_lock();
>       update_ckc_timer(env);
> -    qemu_mutex_unlock_iothread();
> +    qemu_bql_unlock();
>   }
>   
>   void tcg_s390_tod_updated(CPUState *cs, run_on_cpu_data opaque)
> @@ -229,9 +229,9 @@ uint32_t HELPER(sck)(CPUS390XState *env, uint64_t tod_low)
>           .low = tod_low,
>       };
>   
> -    qemu_mutex_lock_iothread();
> +    qemu_bql_lock();
>       tdc->set(td, &tod, &error_abort);
> -    qemu_mutex_unlock_iothread();
> +    qemu_bql_unlock();
>       return 0;
>   }
>   
> @@ -421,9 +421,9 @@ uint32_t HELPER(sigp)(CPUS390XState *env, uint64_t order_code, uint32_t r1,
>       int cc;
>   
>       /* TODO: needed to inject interrupts  - push further down */
> -    qemu_mutex_lock_iothread();
> +    qemu_bql_lock();
>       cc = handle_sigp(env, order_code & SIGP_ORDER_MASK, r1, r3);
> -    qemu_mutex_unlock_iothread();
> +    qemu_bql_unlock();
>   
>       return cc;
>   }
> @@ -433,92 +433,92 @@ uint32_t HELPER(sigp)(CPUS390XState *env, uint64_t order_code, uint32_t r1,
>   void HELPER(xsch)(CPUS390XState *env, uint64_t r1)
>   {
>       S390CPU *cpu = env_archcpu(env);
> -    qemu_mutex_lock_iothread();
> +    qemu_bql_lock();
>       ioinst_handle_xsch(cpu, r1, GETPC());
> -    qemu_mutex_unlock_iothread();
> +    qemu_bql_unlock();
>   }
>   
>   void HELPER(csch)(CPUS390XState *env, uint64_t r1)
>   {
>       S390CPU *cpu = env_archcpu(env);
> -    qemu_mutex_lock_iothread();
> +    qemu_bql_lock();
>       ioinst_handle_csch(cpu, r1, GETPC());
> -    qemu_mutex_unlock_iothread();
> +    qemu_bql_unlock();
>   }
>   
>   void HELPER(hsch)(CPUS390XState *env, uint64_t r1)
>   {
>       S390CPU *cpu = env_archcpu(env);
> -    qemu_mutex_lock_iothread();
> +    qemu_bql_lock();
>       ioinst_handle_hsch(cpu, r1, GETPC());
> -    qemu_mutex_unlock_iothread();
> +    qemu_bql_unlock();
>   }
>   
>   void HELPER(msch)(CPUS390XState *env, uint64_t r1, uint64_t inst)
>   {
>       S390CPU *cpu = env_archcpu(env);
> -    qemu_mutex_lock_iothread();
> +    qemu_bql_lock();
>       ioinst_handle_msch(cpu, r1, inst >> 16, GETPC());
> -    qemu_mutex_unlock_iothread();
> +    qemu_bql_unlock();
>   }
>   
>   void HELPER(rchp)(CPUS390XState *env, uint64_t r1)
>   {
>       S390CPU *cpu = env_archcpu(env);
> -    qemu_mutex_lock_iothread();
> +    qemu_bql_lock();
>       ioinst_handle_rchp(cpu, r1, GETPC());
> -    qemu_mutex_unlock_iothread();
> +    qemu_bql_unlock();
>   }
>   
>   void HELPER(rsch)(CPUS390XState *env, uint64_t r1)
>   {
>       S390CPU *cpu = env_archcpu(env);
> -    qemu_mutex_lock_iothread();
> +    qemu_bql_lock();
>       ioinst_handle_rsch(cpu, r1, GETPC());
> -    qemu_mutex_unlock_iothread();
> +    qemu_bql_unlock();
>   }
>   
>   void HELPER(sal)(CPUS390XState *env, uint64_t r1)
>   {
>       S390CPU *cpu = env_archcpu(env);
>   
> -    qemu_mutex_lock_iothread();
> +    qemu_bql_lock();
>       ioinst_handle_sal(cpu, r1, GETPC());
> -    qemu_mutex_unlock_iothread();
> +    qemu_bql_unlock();
>   }
>   
>   void HELPER(schm)(CPUS390XState *env, uint64_t r1, uint64_t r2, uint64_t inst)
>   {
>       S390CPU *cpu = env_archcpu(env);
>   
> -    qemu_mutex_lock_iothread();
> +    qemu_bql_lock();
>       ioinst_handle_schm(cpu, r1, r2, inst >> 16, GETPC());
> -    qemu_mutex_unlock_iothread();
> +    qemu_bql_unlock();
>   }
>   
>   void HELPER(ssch)(CPUS390XState *env, uint64_t r1, uint64_t inst)
>   {
>       S390CPU *cpu = env_archcpu(env);
> -    qemu_mutex_lock_iothread();
> +    qemu_bql_lock();
>       ioinst_handle_ssch(cpu, r1, inst >> 16, GETPC());
> -    qemu_mutex_unlock_iothread();
> +    qemu_bql_unlock();
>   }
>   
>   void HELPER(stcrw)(CPUS390XState *env, uint64_t inst)
>   {
>       S390CPU *cpu = env_archcpu(env);
>   
> -    qemu_mutex_lock_iothread();
> +    qemu_bql_lock();
>       ioinst_handle_stcrw(cpu, inst >> 16, GETPC());
> -    qemu_mutex_unlock_iothread();
> +    qemu_bql_unlock();
>   }
>   
>   void HELPER(stsch)(CPUS390XState *env, uint64_t r1, uint64_t inst)
>   {
>       S390CPU *cpu = env_archcpu(env);
> -    qemu_mutex_lock_iothread();
> +    qemu_bql_lock();
>       ioinst_handle_stsch(cpu, r1, inst >> 16, GETPC());
> -    qemu_mutex_unlock_iothread();
> +    qemu_bql_unlock();
>   }
>   
>   uint32_t HELPER(tpi)(CPUS390XState *env, uint64_t addr)
> @@ -533,10 +533,10 @@ uint32_t HELPER(tpi)(CPUS390XState *env, uint64_t addr)
>           tcg_s390_program_interrupt(env, PGM_SPECIFICATION, ra);
>       }
>   
> -    qemu_mutex_lock_iothread();
> +    qemu_bql_lock();
>       io = qemu_s390_flic_dequeue_io(flic, env->cregs[6]);
>       if (!io) {
> -        qemu_mutex_unlock_iothread();
> +        qemu_bql_unlock();
>           return 0;
>       }
>   
> @@ -554,7 +554,7 @@ uint32_t HELPER(tpi)(CPUS390XState *env, uint64_t addr)
>           if (s390_cpu_virt_mem_write(cpu, addr, 0, &intc, sizeof(intc))) {
>               /* writing failed, reinject and properly clean up */
>               s390_io_interrupt(io->id, io->nr, io->parm, io->word);
> -            qemu_mutex_unlock_iothread();
> +            qemu_bql_unlock();
>               g_free(io);
>               s390_cpu_virt_mem_handle_exc(cpu, ra);
>               return 0;
> @@ -570,24 +570,24 @@ uint32_t HELPER(tpi)(CPUS390XState *env, uint64_t addr)
>       }
>   
>       g_free(io);
> -    qemu_mutex_unlock_iothread();
> +    qemu_bql_unlock();
>       return 1;
>   }
>   
>   void HELPER(tsch)(CPUS390XState *env, uint64_t r1, uint64_t inst)
>   {
>       S390CPU *cpu = env_archcpu(env);
> -    qemu_mutex_lock_iothread();
> +    qemu_bql_lock();
>       ioinst_handle_tsch(cpu, r1, inst >> 16, GETPC());
> -    qemu_mutex_unlock_iothread();
> +    qemu_bql_unlock();
>   }
>   
>   void HELPER(chsc)(CPUS390XState *env, uint64_t inst)
>   {
>       S390CPU *cpu = env_archcpu(env);
> -    qemu_mutex_lock_iothread();
> +    qemu_bql_lock();
>       ioinst_handle_chsc(cpu, inst >> 16, GETPC());
> -    qemu_mutex_unlock_iothread();
> +    qemu_bql_unlock();
>   }
>   #endif
>   
> @@ -726,27 +726,27 @@ void HELPER(clp)(CPUS390XState *env, uint32_t r2)
>   {
>       S390CPU *cpu = env_archcpu(env);
>   
> -    qemu_mutex_lock_iothread();
> +    qemu_bql_lock();
>       clp_service_call(cpu, r2, GETPC());
> -    qemu_mutex_unlock_iothread();
> +    qemu_bql_unlock();
>   }
>   
>   void HELPER(pcilg)(CPUS390XState *env, uint32_t r1, uint32_t r2)
>   {
>       S390CPU *cpu = env_archcpu(env);
>   
> -    qemu_mutex_lock_iothread();
> +    qemu_bql_lock();
>       pcilg_service_call(cpu, r1, r2, GETPC());
> -    qemu_mutex_unlock_iothread();
> +    qemu_bql_unlock();
>   }
>   
>   void HELPER(pcistg)(CPUS390XState *env, uint32_t r1, uint32_t r2)
>   {
>       S390CPU *cpu = env_archcpu(env);
>   
> -    qemu_mutex_lock_iothread();
> +    qemu_bql_lock();
>       pcistg_service_call(cpu, r1, r2, GETPC());
> -    qemu_mutex_unlock_iothread();
> +    qemu_bql_unlock();
>   }
>   
>   void HELPER(stpcifc)(CPUS390XState *env, uint32_t r1, uint64_t fiba,
> @@ -754,9 +754,9 @@ void HELPER(stpcifc)(CPUS390XState *env, uint32_t r1, uint64_t fiba,
>   {
>       S390CPU *cpu = env_archcpu(env);
>   
> -    qemu_mutex_lock_iothread();
> +    qemu_bql_lock();
>       stpcifc_service_call(cpu, r1, fiba, ar, GETPC());
> -    qemu_mutex_unlock_iothread();
> +    qemu_bql_unlock();
>   }
>   
>   void HELPER(sic)(CPUS390XState *env, uint64_t r1, uint64_t r3)
> @@ -764,9 +764,9 @@ void HELPER(sic)(CPUS390XState *env, uint64_t r1, uint64_t r3)
>       S390CPU *cpu = env_archcpu(env);
>       int r;
>   
> -    qemu_mutex_lock_iothread();
> +    qemu_bql_lock();
>       r = css_do_sic(cpu, (r3 >> 27) & 0x7, r1 & 0xffff);
> -    qemu_mutex_unlock_iothread();
> +    qemu_bql_unlock();
>       /* css_do_sic() may actually return a PGM_xxx value to inject */
>       if (r) {
>           tcg_s390_program_interrupt(env, -r, GETPC());
> @@ -777,9 +777,9 @@ void HELPER(rpcit)(CPUS390XState *env, uint32_t r1, uint32_t r2)
>   {
>       S390CPU *cpu = env_archcpu(env);
>   
> -    qemu_mutex_lock_iothread();
> +    qemu_bql_lock();
>       rpcit_service_call(cpu, r1, r2, GETPC());
> -    qemu_mutex_unlock_iothread();
> +    qemu_bql_unlock();
>   }
>   
>   void HELPER(pcistb)(CPUS390XState *env, uint32_t r1, uint32_t r3,
> @@ -787,9 +787,9 @@ void HELPER(pcistb)(CPUS390XState *env, uint32_t r1, uint32_t r3,
>   {
>       S390CPU *cpu = env_archcpu(env);
>   
> -    qemu_mutex_lock_iothread();
> +    qemu_bql_lock();
>       pcistb_service_call(cpu, r1, r3, gaddr, ar, GETPC());
> -    qemu_mutex_unlock_iothread();
> +    qemu_bql_unlock();
>   }
>   
>   void HELPER(mpcifc)(CPUS390XState *env, uint32_t r1, uint64_t fiba,
> @@ -797,8 +797,8 @@ void HELPER(mpcifc)(CPUS390XState *env, uint32_t r1, uint64_t fiba,
>   {
>       S390CPU *cpu = env_archcpu(env);
>   
> -    qemu_mutex_lock_iothread();
> +    qemu_bql_lock();
>       mpcifc_service_call(cpu, r1, fiba, ar, GETPC());
> -    qemu_mutex_unlock_iothread();
> +    qemu_bql_unlock();
>   }
>   #endif
> diff --git a/target/sparc/int32_helper.c b/target/sparc/int32_helper.c
> index 1563613582..3fd28a04e7 100644
> --- a/target/sparc/int32_helper.c
> +++ b/target/sparc/int32_helper.c
> @@ -70,7 +70,7 @@ void cpu_check_irqs(CPUSPARCState *env)
>       CPUState *cs;
>   
>       /* We should be holding the BQL before we mess with IRQs */
> -    g_assert(qemu_mutex_iothread_locked());
> +    g_assert(qemu_bql_locked());
>   
>       if (env->pil_in && (env->interrupt_index == 0 ||
>                           (env->interrupt_index & ~15) == TT_EXTINT)) {
> diff --git a/target/sparc/int64_helper.c b/target/sparc/int64_helper.c
> index 1b4155f5f3..dacbbf6b5b 100644
> --- a/target/sparc/int64_helper.c
> +++ b/target/sparc/int64_helper.c
> @@ -69,7 +69,7 @@ void cpu_check_irqs(CPUSPARCState *env)
>                     (env->softint & ~(SOFTINT_TIMER | SOFTINT_STIMER));
>   
>       /* We should be holding the BQL before we mess with IRQs */
> -    g_assert(qemu_mutex_iothread_locked());
> +    g_assert(qemu_bql_locked());
>   
>       /* TT_IVEC has a higher priority (16) than TT_EXTINT (31..17) */
>       if (env->ivec_status & 0x20) {
> @@ -267,9 +267,9 @@ static bool do_modify_softint(CPUSPARCState *env, uint32_t value)
>           env->softint = value;
>   #if !defined(CONFIG_USER_ONLY)
>           if (cpu_interrupts_enabled(env)) {
> -            qemu_mutex_lock_iothread();
> +            qemu_bql_lock();
>               cpu_check_irqs(env);
> -            qemu_mutex_unlock_iothread();
> +            qemu_bql_unlock();
>           }
>   #endif
>           return true;
> diff --git a/target/sparc/win_helper.c b/target/sparc/win_helper.c
> index 16d1c70fe7..ba666ec50e 100644
> --- a/target/sparc/win_helper.c
> +++ b/target/sparc/win_helper.c
> @@ -179,9 +179,9 @@ void helper_wrpsr(CPUSPARCState *env, target_ulong new_psr)
>           cpu_raise_exception_ra(env, TT_ILL_INSN, GETPC());
>       } else {
>           /* cpu_put_psr may trigger interrupts, hence BQL */
> -        qemu_mutex_lock_iothread();
> +        qemu_bql_lock();
>           cpu_put_psr(env, new_psr);
> -        qemu_mutex_unlock_iothread();
> +        qemu_bql_unlock();
>       }
>   }
>   
> @@ -407,9 +407,9 @@ void helper_wrpstate(CPUSPARCState *env, target_ulong new_state)
>   
>   #if !defined(CONFIG_USER_ONLY)
>       if (cpu_interrupts_enabled(env)) {
> -        qemu_mutex_lock_iothread();
> +        qemu_bql_lock();
>           cpu_check_irqs(env);
> -        qemu_mutex_unlock_iothread();
> +        qemu_bql_unlock();
>       }
>   #endif
>   }
> @@ -422,9 +422,9 @@ void helper_wrpil(CPUSPARCState *env, target_ulong new_pil)
>       env->psrpil = new_pil;
>   
>       if (cpu_interrupts_enabled(env)) {
> -        qemu_mutex_lock_iothread();
> +        qemu_bql_lock();
>           cpu_check_irqs(env);
> -        qemu_mutex_unlock_iothread();
> +        qemu_bql_unlock();
>       }
>   #endif
>   }
> @@ -451,9 +451,9 @@ void helper_done(CPUSPARCState *env)
>   
>   #if !defined(CONFIG_USER_ONLY)
>       if (cpu_interrupts_enabled(env)) {
> -        qemu_mutex_lock_iothread();
> +        qemu_bql_lock();
>           cpu_check_irqs(env);
> -        qemu_mutex_unlock_iothread();
> +        qemu_bql_unlock();
>       }
>   #endif
>   }
> @@ -480,9 +480,9 @@ void helper_retry(CPUSPARCState *env)
>   
>   #if !defined(CONFIG_USER_ONLY)
>       if (cpu_interrupts_enabled(env)) {
> -        qemu_mutex_lock_iothread();
> +        qemu_bql_lock();
>           cpu_check_irqs(env);
> -        qemu_mutex_unlock_iothread();
> +        qemu_bql_unlock();
>       }
>   #endif
>   }
> diff --git a/target/xtensa/exc_helper.c b/target/xtensa/exc_helper.c
> index 91354884f7..405387decb 100644
> --- a/target/xtensa/exc_helper.c
> +++ b/target/xtensa/exc_helper.c
> @@ -105,9 +105,9 @@ void HELPER(waiti)(CPUXtensaState *env, uint32_t pc, uint32_t intlevel)
>       env->sregs[PS] = (env->sregs[PS] & ~PS_INTLEVEL) |
>           (intlevel << PS_INTLEVEL_SHIFT);
>   
> -    qemu_mutex_lock_iothread();
> +    qemu_bql_lock();
>       check_interrupts(env);
> -    qemu_mutex_unlock_iothread();
> +    qemu_bql_unlock();
>   
>       if (env->pending_irq_level) {
>           cpu_loop_exit(cpu);
> @@ -120,9 +120,9 @@ void HELPER(waiti)(CPUXtensaState *env, uint32_t pc, uint32_t intlevel)
>   
>   void HELPER(check_interrupts)(CPUXtensaState *env)
>   {
> -    qemu_mutex_lock_iothread();
> +    qemu_bql_lock();
>       check_interrupts(env);
> -    qemu_mutex_unlock_iothread();
> +    qemu_bql_unlock();
>   }
>   
>   void HELPER(intset)(CPUXtensaState *env, uint32_t v)
> diff --git a/ui/spice-core.c b/ui/spice-core.c
> index db21db2c94..1d895d2fe8 100644
> --- a/ui/spice-core.c
> +++ b/ui/spice-core.c
> @@ -222,7 +222,7 @@ static void channel_event(int event, SpiceChannelEventInfo *info)
>        */
>       bool need_lock = !qemu_thread_is_self(&me);
>       if (need_lock) {
> -        qemu_mutex_lock_iothread();
> +        qemu_bql_lock();
>       }
>   
>       if (info->flags & SPICE_CHANNEL_EVENT_FLAG_ADDR_EXT) {
> @@ -260,7 +260,7 @@ static void channel_event(int event, SpiceChannelEventInfo *info)
>       }
>   
>       if (need_lock) {
> -        qemu_mutex_unlock_iothread();
> +        qemu_bql_unlock();
>       }
>   
>       qapi_free_SpiceServerInfo(server);
> diff --git a/util/async.c b/util/async.c
> index 8f90ddc304..49d07b3c73 100644
> --- a/util/async.c
> +++ b/util/async.c
> @@ -741,7 +741,7 @@ AioContext *qemu_get_current_aio_context(void)
>       if (ctx) {
>           return ctx;
>       }
> -    if (qemu_mutex_iothread_locked()) {
> +    if (qemu_bql_locked()) {
>           /* Possibly in a vCPU thread.  */
>           return qemu_get_aio_context();
>       }
> diff --git a/util/main-loop.c b/util/main-loop.c
> index 797b640c41..921fab3f32 100644
> --- a/util/main-loop.c
> +++ b/util/main-loop.c
> @@ -302,13 +302,13 @@ static int os_host_main_loop_wait(int64_t timeout)
>   
>       glib_pollfds_fill(&timeout);
>   
> -    qemu_mutex_unlock_iothread();
> +    qemu_bql_unlock();
>       replay_mutex_unlock();
>   
>       ret = qemu_poll_ns((GPollFD *)gpollfds->data, gpollfds->len, timeout);
>   
>       replay_mutex_lock();
> -    qemu_mutex_lock_iothread();
> +    qemu_bql_lock();
>   
>       glib_pollfds_poll();
>   
> @@ -517,7 +517,7 @@ static int os_host_main_loop_wait(int64_t timeout)
>   
>       poll_timeout_ns = qemu_soonest_timeout(poll_timeout_ns, timeout);
>   
> -    qemu_mutex_unlock_iothread();
> +    qemu_bql_unlock();
>   
>       replay_mutex_unlock();
>   
> @@ -525,7 +525,7 @@ static int os_host_main_loop_wait(int64_t timeout)
>   
>       replay_mutex_lock();
>   
> -    qemu_mutex_lock_iothread();
> +    qemu_bql_lock();
>       if (g_poll_ret > 0) {
>           for (i = 0; i < w->num; i++) {
>               w->revents[i] = poll_fds[n_poll_fds + i].revents;
> diff --git a/util/rcu.c b/util/rcu.c
> index e587bcc483..8331f24288 100644
> --- a/util/rcu.c
> +++ b/util/rcu.c
> @@ -283,24 +283,24 @@ static void *call_rcu_thread(void *opaque)
>   
>           qatomic_sub(&rcu_call_count, n);
>           synchronize_rcu();
> -        qemu_mutex_lock_iothread();
> +        qemu_bql_lock();
>           while (n > 0) {
>               node = try_dequeue();
>               while (!node) {
> -                qemu_mutex_unlock_iothread();
> +                qemu_bql_unlock();
>                   qemu_event_reset(&rcu_call_ready_event);
>                   node = try_dequeue();
>                   if (!node) {
>                       qemu_event_wait(&rcu_call_ready_event);
>                       node = try_dequeue();
>                   }
> -                qemu_mutex_lock_iothread();
> +                qemu_bql_lock();
>               }
>   
>               n--;
>               node->func(node);
>           }
> -        qemu_mutex_unlock_iothread();
> +        qemu_bql_unlock();
>       }
>       abort();
>   }
> @@ -337,13 +337,13 @@ static void drain_rcu_callback(struct rcu_head *node)
>   void drain_call_rcu(void)
>   {
>       struct rcu_drain rcu_drain;
> -    bool locked = qemu_mutex_iothread_locked();
> +    bool locked = qemu_bql_locked();
>   
>       memset(&rcu_drain, 0, sizeof(struct rcu_drain));
>       qemu_event_init(&rcu_drain.drain_complete_event, false);
>   
>       if (locked) {
> -        qemu_mutex_unlock_iothread();
> +        qemu_bql_unlock();
>       }
>   
>   
> @@ -365,7 +365,7 @@ void drain_call_rcu(void)
>       qatomic_dec(&in_drain_call_rcu);
>   
>       if (locked) {
> -        qemu_mutex_lock_iothread();
> +        qemu_bql_lock();
>       }
>   
>   }
> diff --git a/audio/coreaudio.m b/audio/coreaudio.m
> index 8cd129a27d..866d7a9436 100644
> --- a/audio/coreaudio.m
> +++ b/audio/coreaudio.m
> @@ -547,7 +547,7 @@ static OSStatus handle_voice_change(
>   {
>       coreaudioVoiceOut *core = in_client_data;
>   
> -    qemu_mutex_lock_iothread();
> +    qemu_bql_lock();
>   
>       if (core->outputDeviceID) {
>           fini_out_device(core);
> @@ -557,7 +557,7 @@ static OSStatus handle_voice_change(
>           update_device_playback_state(core);
>       }
>   
> -    qemu_mutex_unlock_iothread();
> +    qemu_bql_unlock();
>       return 0;
>   }
>   
> diff --git a/memory_ldst.c.inc b/memory_ldst.c.inc
> index 84b868f294..cd8a629816 100644
> --- a/memory_ldst.c.inc
> +++ b/memory_ldst.c.inc
> @@ -61,7 +61,7 @@ static inline uint32_t glue(address_space_ldl_internal, SUFFIX)(ARG1_DECL,
>           *result = r;
>       }
>       if (release_lock) {
> -        qemu_mutex_unlock_iothread();
> +        qemu_bql_unlock();
>       }
>       RCU_READ_UNLOCK();
>       return val;
> @@ -130,7 +130,7 @@ static inline uint64_t glue(address_space_ldq_internal, SUFFIX)(ARG1_DECL,
>           *result = r;
>       }
>       if (release_lock) {
> -        qemu_mutex_unlock_iothread();
> +        qemu_bql_unlock();
>       }
>       RCU_READ_UNLOCK();
>       return val;
> @@ -186,7 +186,7 @@ uint8_t glue(address_space_ldub, SUFFIX)(ARG1_DECL,
>           *result = r;
>       }
>       if (release_lock) {
> -        qemu_mutex_unlock_iothread();
> +        qemu_bql_unlock();
>       }
>       RCU_READ_UNLOCK();
>       return val;
> @@ -234,7 +234,7 @@ static inline uint16_t glue(address_space_lduw_internal, SUFFIX)(ARG1_DECL,
>           *result = r;
>       }
>       if (release_lock) {
> -        qemu_mutex_unlock_iothread();
> +        qemu_bql_unlock();
>       }
>       RCU_READ_UNLOCK();
>       return val;
> @@ -295,7 +295,7 @@ void glue(address_space_stl_notdirty, SUFFIX)(ARG1_DECL,
>           *result = r;
>       }
>       if (release_lock) {
> -        qemu_mutex_unlock_iothread();
> +        qemu_bql_unlock();
>       }
>       RCU_READ_UNLOCK();
>   }
> @@ -339,7 +339,7 @@ static inline void glue(address_space_stl_internal, SUFFIX)(ARG1_DECL,
>           *result = r;
>       }
>       if (release_lock) {
> -        qemu_mutex_unlock_iothread();
> +        qemu_bql_unlock();
>       }
>       RCU_READ_UNLOCK();
>   }
> @@ -391,7 +391,7 @@ void glue(address_space_stb, SUFFIX)(ARG1_DECL,
>           *result = r;
>       }
>       if (release_lock) {
> -        qemu_mutex_unlock_iothread();
> +        qemu_bql_unlock();
>       }
>       RCU_READ_UNLOCK();
>   }
> @@ -435,7 +435,7 @@ static inline void glue(address_space_stw_internal, SUFFIX)(ARG1_DECL,
>           *result = r;
>       }
>       if (release_lock) {
> -        qemu_mutex_unlock_iothread();
> +        qemu_bql_unlock();
>       }
>       RCU_READ_UNLOCK();
>   }
> @@ -499,7 +499,7 @@ static void glue(address_space_stq_internal, SUFFIX)(ARG1_DECL,
>           *result = r;
>       }
>       if (release_lock) {
> -        qemu_mutex_unlock_iothread();
> +        qemu_bql_unlock();
>       }
>       RCU_READ_UNLOCK();
>   }
> diff --git a/target/i386/hvf/README.md b/target/i386/hvf/README.md
> index 2d33477aca..679b93b630 100644
> --- a/target/i386/hvf/README.md
> +++ b/target/i386/hvf/README.md
> @@ -4,4 +4,4 @@ These sources (and ../hvf-all.c) are adapted from Veertu Inc's vdhh (Veertu Desk
>   
>   1. Adapt to our current QEMU's `CPUState` structure and `address_space_rw` API; many struct members have been moved around (emulated x86 state, xsave_buf) due to historical differences + QEMU needing to handle more emulation targets.
>   2. Removal of `apic_page` and hyperv-related functionality.
> -3. More relaxed use of `qemu_mutex_lock_iothread`.
> +3. More relaxed use of `qemu_bql_lock`.
> diff --git a/ui/cocoa.m b/ui/cocoa.m
> index cd069da696..8a7d0a6f0c 100644
> --- a/ui/cocoa.m
> +++ b/ui/cocoa.m
> @@ -117,29 +117,29 @@ static void cocoa_switch(DisplayChangeListener *dcl,
>   typedef void (^CodeBlock)(void);
>   typedef bool (^BoolCodeBlock)(void);
>   
> -static void with_iothread_lock(CodeBlock block)
> +static void with_bql(CodeBlock block)
>   {
> -    bool locked = qemu_mutex_iothread_locked();
> +    bool locked = qemu_bql_locked();
>       if (!locked) {
> -        qemu_mutex_lock_iothread();
> +        qemu_bql_lock();
>       }
>       block();
>       if (!locked) {
> -        qemu_mutex_unlock_iothread();
> +        qemu_bql_unlock();
>       }
>   }
>   
> -static bool bool_with_iothread_lock(BoolCodeBlock block)
> +static bool bool_with_bql(BoolCodeBlock block)
>   {
> -    bool locked = qemu_mutex_iothread_locked();
> +    bool locked = qemu_bql_locked();
>       bool val;
>   
>       if (!locked) {
> -        qemu_mutex_lock_iothread();
> +        qemu_bql_lock();
>       }
>       val = block();
>       if (!locked) {
> -        qemu_mutex_unlock_iothread();
> +        qemu_bql_unlock();
>       }
>       return val;
>   }
> @@ -605,7 +605,7 @@ - (void) updateUIInfo
>           return;
>       }
>   
> -    with_iothread_lock(^{
> +    with_bql(^{
>           [self updateUIInfoLocked];
>       });
>   }
> @@ -790,7 +790,7 @@ - (void) handleMonitorInput:(NSEvent *)event
>   
>   - (bool) handleEvent:(NSEvent *)event
>   {
> -    return bool_with_iothread_lock(^{
> +    return bool_with_bql(^{
>           return [self handleEventLocked:event];
>       });
>   }
> @@ -1182,7 +1182,7 @@ - (QEMUScreen) gscreen {return screen;}
>    */
>   - (void) raiseAllKeys
>   {
> -    with_iothread_lock(^{
> +    with_bql(^{
>           qkbd_state_lift_all_keys(kbd);
>       });
>   }
> @@ -1282,7 +1282,7 @@ - (void)applicationWillTerminate:(NSNotification *)aNotification
>   {
>       COCOA_DEBUG("QemuCocoaAppController: applicationWillTerminate\n");
>   
> -    with_iothread_lock(^{
> +    with_bql(^{
>           shutdown_action = SHUTDOWN_ACTION_POWEROFF;
>           qemu_system_shutdown_request(SHUTDOWN_CAUSE_HOST_UI);
>       });
> @@ -1420,7 +1420,7 @@ - (void)displayConsole:(id)sender
>   /* Pause the guest */
>   - (void)pauseQEMU:(id)sender
>   {
> -    with_iothread_lock(^{
> +    with_bql(^{
>           qmp_stop(NULL);
>       });
>       [sender setEnabled: NO];
> @@ -1431,7 +1431,7 @@ - (void)pauseQEMU:(id)sender
>   /* Resume running the guest operating system */
>   - (void)resumeQEMU:(id) sender
>   {
> -    with_iothread_lock(^{
> +    with_bql(^{
>           qmp_cont(NULL);
>       });
>       [sender setEnabled: NO];
> @@ -1461,7 +1461,7 @@ - (void)removePause
>   /* Restarts QEMU */
>   - (void)restartQEMU:(id)sender
>   {
> -    with_iothread_lock(^{
> +    with_bql(^{
>           qmp_system_reset(NULL);
>       });
>   }
> @@ -1469,7 +1469,7 @@ - (void)restartQEMU:(id)sender
>   /* Powers down QEMU */
>   - (void)powerDownQEMU:(id)sender
>   {
> -    with_iothread_lock(^{
> +    with_bql(^{
>           qmp_system_powerdown(NULL);
>       });
>   }
> @@ -1488,7 +1488,7 @@ - (void)ejectDeviceMedia:(id)sender
>       }
>   
>       __block Error *err = NULL;
> -    with_iothread_lock(^{
> +    with_bql(^{
>           qmp_eject([drive cStringUsingEncoding: NSASCIIStringEncoding],
>                     NULL, false, false, &err);
>       });
> @@ -1523,7 +1523,7 @@ - (void)changeDeviceMedia:(id)sender
>           }
>   
>           __block Error *err = NULL;
> -        with_iothread_lock(^{
> +        with_bql(^{
>               qmp_blockdev_change_medium([drive cStringUsingEncoding:
>                                                     NSASCIIStringEncoding],
>                                          NULL,
> @@ -1605,7 +1605,7 @@ - (void)adjustSpeed:(id)sender
>       // get the throttle percentage
>       throttle_pct = [sender tag];
>   
> -    with_iothread_lock(^{
> +    with_bql(^{
>           cpu_throttle_set(throttle_pct);
>       });
>       COCOA_DEBUG("cpu throttling at %d%c\n", cpu_throttle_get_percentage(), '%');
> @@ -1819,7 +1819,7 @@ - (void)pasteboard:(NSPasteboard *)sender provideDataForType:(NSPasteboardType)t
>           return;
>       }
>   
> -    with_iothread_lock(^{
> +    with_bql(^{
>           QemuClipboardInfo *info = qemu_clipboard_info_ref(cbinfo);
>           qemu_event_reset(&cbevent);
>           qemu_clipboard_request(info, QEMU_CLIPBOARD_TYPE_TEXT);
> @@ -1827,9 +1827,9 @@ - (void)pasteboard:(NSPasteboard *)sender provideDataForType:(NSPasteboardType)t
>           while (info == cbinfo &&
>                  info->types[QEMU_CLIPBOARD_TYPE_TEXT].available &&
>                  info->types[QEMU_CLIPBOARD_TYPE_TEXT].data == NULL) {
> -            qemu_mutex_unlock_iothread();
> +            qemu_bql_unlock();
>               qemu_event_wait(&cbevent);
> -            qemu_mutex_lock_iothread();
> +            qemu_bql_lock();
>           }
>   
>           if (info == cbinfo) {
> @@ -1927,9 +1927,9 @@ static void cocoa_clipboard_request(QemuClipboardInfo *info,
>       int status;
>   
>       COCOA_DEBUG("Second thread: calling qemu_default_main()\n");
> -    qemu_mutex_lock_iothread();
> +    qemu_bql_lock();
>       status = qemu_default_main();
> -    qemu_mutex_unlock_iothread();
> +    qemu_bql_unlock();
>       COCOA_DEBUG("Second thread: qemu_default_main() returned, exiting\n");
>       [cbowner release];
>       exit(status);
> @@ -1941,7 +1941,7 @@ static int cocoa_main(void)
>   
>       COCOA_DEBUG("Entered %s()\n", __func__);
>   
> -    qemu_mutex_unlock_iothread();
> +    qemu_bql_unlock();
>       qemu_thread_create(&thread, "qemu_main", call_qemu_main,
>                          NULL, QEMU_THREAD_DETACHED);
>   

