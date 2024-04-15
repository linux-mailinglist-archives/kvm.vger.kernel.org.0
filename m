Return-Path: <kvm+bounces-14630-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C57568A4A1E
	for <lists+kvm@lfdr.de>; Mon, 15 Apr 2024 10:15:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 43F7A1F243B6
	for <lists+kvm@lfdr.de>; Mon, 15 Apr 2024 08:15:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6045A383A3;
	Mon, 15 Apr 2024 08:14:55 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BB53C2E636;
	Mon, 15 Apr 2024 08:14:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713168894; cv=none; b=FG8DCs0TRa8aZgix3HHAbXQf2cUANWDOjpwPlCf3qb2dA/ATKXEzsFtmagcevkdBJvbvluOMmcEJ364jofQJYnmD1A/HqNjCDmoWxqlrjExZCMFGPitr0hac0l2c5aUrLvupeFBmM6cxfhEeROSlqtt50rQsqHPCAcGqXoedmL0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713168894; c=relaxed/simple;
	bh=hGxCv7AEdjH+aTdPB4ukWB+FgR2cH1DNlmjRf6pRFoc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DM809OVPNo7i1UjrYJYjy7g4H362LsJ6QnTks5JcziSbqoetPz7roh1FMrZQ3BthmfcU20ExsPwbRgEUT7nGU6HMZPGdDxoIwOx36tQucVlNu5ujv4Im7yPAUU4nL5hD5arl+HLv8HtON/6ipqrh0jvARuLS/wFRWiCOJYmR4i8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 524A02F;
	Mon, 15 Apr 2024 01:15:20 -0700 (PDT)
Received: from [10.57.76.98] (unknown [10.57.76.98])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 16BD73F64C;
	Mon, 15 Apr 2024 01:14:46 -0700 (PDT)
Message-ID: <b2accd2c-15cc-44d9-9191-60224b797814@arm.com>
Date: Mon, 15 Apr 2024 09:14:47 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [v2] Support for Arm CCA VMs on Linux
To: Itaru Kitayama <itaru.kitayama@linux.dev>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev,
 Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>, Fuad Tabba <tabba@google.com>,
 linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
References: <20240412084056.1733704-1-steven.price@arm.com>
 <Zhgx1IDhEYo27OAR@vm3>
From: Steven Price <steven.price@arm.com>
Content-Language: en-GB
In-Reply-To: <Zhgx1IDhEYo27OAR@vm3>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/04/2024 19:54, Itaru Kitayama wrote:
> Hi Steven,
> 
> On Fri, Apr 12, 2024 at 09:40:56AM +0100, Steven Price wrote:
>> We are happy to announce the second version of the Arm Confidential
>> Compute Architecture (CCA) support for the Linux stack. The intention is
>> to seek early feedback in the following areas:
>>  * KVM integration of the Arm CCA;
>>  * KVM UABI for managing the Realms, seeking to generalise the
>>    operations where possible with other Confidential Compute solutions;
>>  * Linux Guest support for Realms.
>>
>> See the previous RFC[1] for a more detailed overview of Arm's CCA
>> solution, or visible the Arm CCA Landing page[2].
>>
>> This series is based on the final RMM v1.0 (EAC5) specification[3].
> 
> It's great to see the updated "V2" series. Since you said you like
> "early" feedback on V2, does that mean it's likely to be followed by
> V3 and V4, anticipating large code-base changes from the current form
> (V2)? Do you have a rough timeframe to make this Arm CCA support landed
> in mainline? Do you Arm folk expect this is going to be a multiple-year 
> long project? 

I probably should have expanded on that wording a bit, sorry! ;)

I decided to drop the 'RFC' tag as I believe this is now in a state
where it's not got any known bugs. The previous RFC didn't use
guest_memfd and had a known issue where a malicious VMM could bring down
the host kernel - so was obviously not ready for merging. But, of
course, "no known bugs" and ready to merge are somewhat different
milestones.

The support for running in a guest is (I believe) in a good state and I
don't expect to have to iterate much on that before merging - but, as
always, that depends on the feedback received.

The host support I expect to take longer. The key thing here is that
there are other CoCo solutions and we don't want to deviate
unnecessarily from what gets merged for them. Most obviously there is
some overlap between pKVM and Arm's CCA as they both touch the Arm arch
code in similar ways. At the moment we've got a hacked up version of the
kvmtool based on pKVM's branch for testing this, but if you've been
following the threads on pKVM you will be aware that there is a question
over whether the guest_memfd support meets pKVM's needs. So there are
definite questions as to what long term approach works best here. There
is even the possibility that if pKVM can solve the issues using
anonymous memory then it may make sense to also switch Arm's CCA back to
using anonymous memory rather than guest_memfd. Although I expect we'll
want to keep guest_memfd as an option at the very least to match where
x86 is heading.

I'd also expect some minor iteration on the exact form the uAPI takes.
Of particular note is Intel is planing to introduce KVM_MAP_MEMORY[1]
which looks very similar to KVM_CAP_ARM_RME_POPULATE_REALM. It will
probably make sense for us to switch (although KVM_MAP_MEMORY has
restrictions which are unnecessary for Arm CCA - e.g. it's run on a vcpu
for x86 but not for Arm CCA).

In terms of timescales - honestly I don't really know. I certainly hope
this won't be as long as "multi-year"! Although the wider CoCo effort is
certainly going to take multiple years. This series is for "CCA v1.0",
there will be more versions of the RMM specification which will add more
features in the future. Equally there is likely to be a lot of work
needed in guest hardening which is largely generic across all CoCo
solutions.

Steve

[1]
https://lore.kernel.org/r/9a060293c9ad9a78f1d8994cfe1311e818e99257.1712785629.git.isaku.yamahata%40intel.com

> Thanks,
> Itaru.
> 
>>
>> Quick-start guide
>> =================
>>
>> The easiest way of getting started with the stack is by using
>> Shrinkwrap[4]. Currently Shrinkwrap has a configuration for the initial
>> v1.0-EAC5 release[5], so the following overlay needs to be applied to
>> the standard 'cca-3world.yaml' file. Note that the 'rmm' component needs
>> updating to 'main' because there are fixes that are needed and are not
>> yet in a tagged release. The following will create an overlay file and
>> build a working environment:
>>
>> cat<<EOT >cca-v2.yaml
>> build:
>>   linux:
>>     repo:
>>       revision: cca-full/v2
>>   kvmtool:
>>     repo:
>>       kvmtool:
>>         revision: cca/v2
>>   rmm:
>>     repo:
>>       revision: main
>>   kvm-unit-tests:
>>     repo:
>>       revision: cca/v2
>> EOT
>>
>> shrinkwrap build cca-3world.yaml --overlay buildroot.yaml --btvar GUEST_ROOTFS='${artifact:BUILDROOT}' --overlay cca-v2.yaml
>>
>> You will then want to modify the 'guest-disk.img' to include the files
>> necessary for the realm guest (see the documentation in cca-3world.yaml
>> for details of other options):
>>
>>   cd ~/.shrinkwrap/package/cca-3world
>>   /sbin/e2fsck -fp rootfs.ext2 
>>   /sbin/resize2fs rootfs.ext2 256M
>>   mkdir mnt
>>   sudo mount rootfs.ext2 mnt/
>>   sudo mkdir mnt/cca
>>   sudo cp guest-disk.img KVMTOOL_EFI.fd lkvm Image mnt/cca/
>>   sudo umount mnt 
>>   rmdir mnt/
>>
>> Finally you can run the FVP with the host:
>>
>>   shrinkwrap run cca-3world.yaml --rtvar ROOTFS=$HOME/.shrinkwrap/package/cca-3world/rootfs.ext2
>>
>> And once the host kernel has booted, login (user name 'root') and start
>> a realm guest:
>>
>>   cd /cca
>>   ./lkvm run --realm --restricted_mem -c 2 -m 256 -k Image -p earlycon
>>
>> Be patient and you should end up in a realm guest with the host's
>> filesystem mounted via p9.
>>
>> It's also possible to use EFI within the realm guest, again see
>> cca-3world.yaml within Shrinkwrap for more details.
>>
>> An branch of kvm-unit-tests including realm-specific tests is provided
>> here:
>>   https://gitlab.arm.com/linux-arm/kvm-unit-tests-cca/-/tree/cca/v2
>>
>> [1] Previous RFC
>>     https://lore.kernel.org/r/20230127112248.136810-1-suzuki.poulose%40arm.com
>> [2] Arm CCA Landing page (See Key Resources section for various documentation)
>>     https://www.arm.com/architecture/security-features/arm-confidential-compute-architecture
>> [3] RMM v1.0-EAC5 specification
>>     https://developer.arm.com/documentation/den0137/1-0eac5/
>> [4] Shrinkwrap
>>     https://git.gitlab.arm.com/tooling/shrinkwrap
>> [5] Linux support for Arm CCA RMM v1.0-EAC5
>>     https://lore.kernel.org/r/fb259449-026e-4083-a02b-f8a4ebea1f87%40arm.com


