Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38EF070E681
	for <lists+kvm@lfdr.de>; Tue, 23 May 2023 22:33:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238375AbjEWUdA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 May 2023 16:33:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233535AbjEWUc7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 May 2023 16:32:59 -0400
Received: from mail.zytor.com (unknown [IPv6:2607:7c80:54:3::138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D12A3BB;
        Tue, 23 May 2023 13:32:57 -0700 (PDT)
Received: from [127.0.0.1] ([73.231.166.163])
        (authenticated bits=0)
        by mail.zytor.com (8.17.1/8.17.1) with ESMTPSA id 34NKVZvn2821465
        (version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
        Tue, 23 May 2023 13:31:35 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 34NKVZvn2821465
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
        s=2023051001; t=1684873896;
        bh=j48OLSwG1gjUAr7jSdrExwOtC18vWxxR2v3o37+/ivU=;
        h=Date:From:To:Subject:In-Reply-To:References:From;
        b=RthoEZm75qRPIUTB89o0F+MAJd3/jy2JpXCa8RhNp7HlSjDG/crOzuR6eSf687wrR
         o2u+iYhVfw1mpyGKtIv4Am97beqMbAyh/wWR4dbRa/MmJkW5GJ9Q05pADeg8uYwYC7
         Urfnq3iLfLXh21U82Pk86g+T5ql618qkgLD+ivI8ZB+0RDw80U9ACZ5MQ1tOJW+aGQ
         xW+MxZg49gKuPBPz9Vj/nk5mWt9WnNsGt6uPXfmCYDbVuO8CfHFCbTfonX7ULfvAR2
         fQjwgN0X9ZduCLAhGlzOwxO6+km+0Tz5F9s8vYItSdmDslLGHIM9ehg0w+4KMkkwpZ
         IPjKz/DhKbf6A==
Date:   Tue, 23 May 2023 13:31:31 -0700
From:   "H. Peter Anvin" <hpa@zytor.com>
To:     Tim Wiederhake <twiederh@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Ingo Molnar <mingo@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH 2/2] x86/msr: Allow unprivileged read access to some MSRs
User-Agent: K-9 Mail for Android
In-Reply-To: <20230523194949.96149-2-twiederh@redhat.com>
References: <20230523194949.96149-1-twiederh@redhat.com> <20230523194949.96149-2-twiederh@redhat.com>
Message-ID: <25E09D2E-E918-4B1D-B307-54F9A801FCF8@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On May 23, 2023 12:49:49 PM PDT, Tim Wiederhake <twiederh@redhat=2Ecom> wro=
te:
>Delaying access control allows unprivileged processes to
>read specific MSRs, such as IA32_CORE_CAPABILITIES and
>IA32_ARCH_CAPABILITIES=2E This is helpful for e=2Eg=2E qemu and
>libvirt who require the raw MSR content to calculate host
>CPU capabilities=2E Other programs might be interested in
>IA32_EFER for x86-64-v1 detection=2E
>
>Signed-off-by: Tim Wiederhake <twiederh@redhat=2Ecom>
>---
> arch/x86/kernel/msr=2Ec | 38 +++++++++++++++++++++++++++++++++-----
> 1 file changed, 33 insertions(+), 5 deletions(-)
>
>diff --git a/arch/x86/kernel/msr=2Ec b/arch/x86/kernel/msr=2Ec
>index 058f2b67d0c7=2E=2E9485aa7f8161 100644
>--- a/arch/x86/kernel/msr=2Ec
>+++ b/arch/x86/kernel/msr=2Ec
>@@ -50,6 +50,23 @@ enum allow_write_msrs {
>=20
> static enum allow_write_msrs allow_writes =3D MSR_WRITES_DEFAULT;
>=20
>+static int filter_read(struct file *file, u32 reg)
>+{
>+	if (file->private_data)
>+		return 0;
>+
>+	switch (reg) {
>+	case MSR_IA32_CORE_CAPS:
>+	case MSR_IA32_ARCH_CAPABILITIES:
>+	case MSR_EFER:
>+		return 0;
>+	default:
>+		break;
>+	}
>+
>+	return -EPERM;
>+}
>+
> static ssize_t msr_read(struct file *file, char __user *buf,
> 			size_t count, loff_t *ppos)
> {
>@@ -59,6 +76,10 @@ static ssize_t msr_read(struct file *file, char __user=
 *buf,
> 	int cpu =3D iminor(file_inode(file));
> 	int err =3D 0;
>=20
>+	err =3D filter_read(file, reg);
>+	if (err)
>+		return err;
>+
> 	if (count < 8)
> 		return -EINVAL;	/* Invalid chunk size */
>=20
>@@ -71,7 +92,7 @@ static ssize_t msr_read(struct file *file, char __user =
*buf,
> 	return 8;
> }
>=20
>-static int filter_write(u32 reg)
>+static int filter_write(struct file *file, u32 reg)
> {
> 	/*
> 	 * MSRs writes usually happen all at once, and can easily saturate kmsg=
=2E
>@@ -83,6 +104,9 @@ static int filter_write(u32 reg)
> 	 */
> 	static DEFINE_RATELIMIT_STATE(fw_rs, 30 * HZ, 1);
>=20
>+	if (!file->private_data)
>+		return -EPERM;
>+
> 	switch (allow_writes) {
> 	case MSR_WRITES_ON:  return 0;
> 	case MSR_WRITES_OFF: return -EPERM;
>@@ -113,7 +137,7 @@ static ssize_t msr_write(struct file *file, const cha=
r __user *buf,
> 	if (err)
> 		return err;
>=20
>-	err =3D filter_write(reg);
>+	err =3D filter_write(file, reg);
> 	if (err)
> 		return err;
>=20
>@@ -156,6 +180,9 @@ static long msr_ioctl(struct file *file, unsigned int=
 ioc, unsigned long arg)
> 			err =3D -EFAULT;
> 			break;
> 		}
>+		err =3D filter_read(file, regs[1]);
>+		if (err)
>+			return err;
> 		err =3D rdmsr_safe_regs_on_cpu(cpu, regs);
> 		if (err)
> 			break;
>@@ -176,7 +203,7 @@ static long msr_ioctl(struct file *file, unsigned int=
 ioc, unsigned long arg)
> 		if (err)
> 			break;
>=20
>-		err =3D filter_write(regs[1]);
>+		err =3D filter_write(file, regs[1]);
> 		if (err)
> 			return err;
>=20
>@@ -202,8 +229,7 @@ static int msr_open(struct inode *inode, struct file =
*file)
> 	unsigned int cpu =3D iminor(file_inode(file));
> 	struct cpuinfo_x86 *c;
>=20
>-	if (!capable(CAP_SYS_RAWIO))
>-		return -EPERM;
>+	file->private_data =3D (void *)(capable(CAP_SYS_RAWIO));
>=20
> 	if (cpu >=3D nr_cpu_ids || !cpu_online(cpu))
> 		return -ENXIO;	/* No such CPU */
>@@ -245,6 +271,8 @@ static int msr_device_destroy(unsigned int cpu)
>=20
> static char *msr_devnode(const struct device *dev, umode_t *mode)
> {
>+	if (mode)
>+		*mode =3D 0644;
> 	return kasprintf(GFP_KERNEL, "cpu/%u/msr", MINOR(dev->devt));
> }
>=20

I believe the preferred way to do this is to export "cooked" information i=
n sysfs=2E /dev/msr really should be considered a legacy, very low-level in=
terface suitable only for restricted environments=2E

When I wrote this driver, it was a maxim that "root owns the system"; ther=
e was no way to restrict privileged interfaces like /dev/(k)mem, /dev/iopor=
ts, or kernel module installation from root; any of these interfaces can be=
 trivially used to take full command of the hardware=2E

This is no longer the case, and it is better for the kernel to only export=
 known good information at the semantic level=2E There is no inherent guara=
ntee that any of these registers may not contain security sensitive informa=
tion in the future=2E

At this point, /dev/msr should be considered a debugging-only interface (f=
or which it is quite useful still=2E)

So NAK on allowing any kind of access without CAP_SYS_RAWIO=2E

NAK on your other patch, too, because it is based on an invalid assumption=
: read/write to /dev/msr does *not* advance the file pointer=2E This is ana=
logous to /dev/ioports, rather than /dev/mem=2E

Incidentally, you have touched on a potential issue here: I suspect that w=
e should check CAP_SYS_RAWIO for each access =E2=80=93 the old policy of "i=
f you can open it you can give someone else a file descriptor" probably no =
longer makes any sense, at least without some kind of mechanism to filter a=
ccess control for a specific fd=2E (Then again, the idiom of "open then dro=
p privileges" might justify caching the capability=2E)



