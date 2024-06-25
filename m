Return-Path: <kvm+bounces-20438-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id E28E0915B90
	for <lists+kvm@lfdr.de>; Tue, 25 Jun 2024 03:20:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4078DB211E6
	for <lists+kvm@lfdr.de>; Tue, 25 Jun 2024 01:20:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6B3E1179BF;
	Tue, 25 Jun 2024 01:20:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=amd.com header.i=@amd.com header.b="5QCKqtxD"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2045.outbound.protection.outlook.com [40.107.236.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 283D1168BE
	for <kvm@vger.kernel.org>; Tue, 25 Jun 2024 01:19:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719278399; cv=fail; b=PI5iZn6LWe7/mQp4ZVzudTQB0mkeF8phbh+pplfS4ntJIRsNL+zfIKz/gn6hO6rjKsCWaZTXBGhEHmIIg/XTlcxQs3dEUYn9QncXuA4nHA/BQgp+aXPxWm6AC7KdGhPgYLIwjtnDpFhAJr+je0O3nEOVLOtqnnibpgnxeYqCCf4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719278399; c=relaxed/simple;
	bh=sl0lyW8pYuGzyeyQ1jvv6E6nKB2QAm8AK3ZBz9Oi4II=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uv6Hptq8e/eM4zDWpp+oPP2TxJRa7hbH0RVlS0U/brYjKDEqnp0oY1rPlfU2gPY6gBR1DshAhSSYN6rwNm1BZSRlZVXeO9//5KiOVLrqAz0gWatntInu7NJIqzh0Z4o1ONttFTR1fcCFmCj4IYQCIGqBaf2fmvSqXTkVqokav9U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=fail (1024-bit key) header.d=amd.com header.i=@amd.com header.b=5QCKqtxD reason="signature verification failed"; arc=fail smtp.client-ip=40.107.236.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B+LcXtBHQHwFs0nl1addgJufAX8Kk6V4FXxiV8uO7rrs4WXdgZLDOW1lPSJWlf4CFChN9iGmYkVF7tWydYEO1gb9Heu/C32wzYjr7GCIs990e8d8sXtbep0qx0rhFqN9klCBC4STqnn/oPkF6uBXWHiSRLo04xMW4pl1gF6In0dqtGnnbrLkrdPhgWkvtZQ2E6UCbKa9azbkpPEwf2zrGijFQ8s34a0mrIR4dveELd1ySK7otcx/AJ/iWbDIVHMWPOkRXmk0Gfex/OMrk3zDUFMVNfi9r96G/KWQATeLArvgaJUUL0WdLBJ9FudDGochUXnrArfvyQ9qM9QvHTLsew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=njbhRRMTin575vJYPTH/Oc3pcsrizaSX1B5MMU6q/XQ=;
 b=nPVgcb9zMmL4DR1OWlIi0pmWOiU82BmBb/mKfnQEg50nhaJZpqMHA8MZboLARBPiJBoB6M6lnYyYFJX7WsPLX3pFE41QN6lO5/NSF7ugztDKug525q5HaUIdxFdjb1rXSxv1tYcEwPvsWvuA9PPVMuERAbLfzlUNfRN7TLhfr80hdUtKDvjZQIZ/+qnpXnBJnitdW0bq/MPxVkGV7SugWdWkG3G/7Ka9nxqS5BVR3DXS8f4WM319/sqUMavYF3uuvkDvV2bEezHtSu171uaGWBaS03U13/eFA4wEdPp8Twn9ka4BeFDtAoYmI41/R7TZkjHPCxaqfOFAY/yVIlc7Ug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=njbhRRMTin575vJYPTH/Oc3pcsrizaSX1B5MMU6q/XQ=;
 b=5QCKqtxDioGaAiUzO9FqKIYvJoCkJtG+zTNy11csOMbjJBKYVySOaADa0KcfmS5QJdfPzS5CFMRF2ZkJtZ/f+VEe8e1OpbOzgJ9g177OtDj2TtpaydEjhqsB++welnm9DSps6itYFn1sWmIY92I4kIhHoz3vQWgrx/n45XCVZe4=
Received: from MW4PR04CA0164.namprd04.prod.outlook.com (2603:10b6:303:85::19)
 by BL3PR12MB6427.namprd12.prod.outlook.com (2603:10b6:208:3b6::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7698.30; Tue, 25 Jun
 2024 01:19:50 +0000
Received: from CO1PEPF000042A8.namprd03.prod.outlook.com
 (2603:10b6:303:85:cafe::6c) by MW4PR04CA0164.outlook.office365.com
 (2603:10b6:303:85::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7677.38 via Frontend
 Transport; Tue, 25 Jun 2024 01:19:49 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1PEPF000042A8.mail.protection.outlook.com (10.167.243.37) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7677.15 via Frontend Transport; Tue, 25 Jun 2024 01:19:49 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 24 Jun
 2024 20:19:47 -0500
Date: Mon, 24 Jun 2024 20:19:19 -0500
From: Michael Roth <michael.roth@amd.com>
To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
CC: <qemu-devel@nongnu.org>, Paolo Bonzini <pbonzini@redhat.com>, Eduardo
 Habkost <eduardo@habkost.net>, Richard Henderson
	<richard.henderson@linaro.org>, Marcel Apfelbaum
	<marcel.apfelbaum@gmail.com>, "Michael S. Tsirkin" <mst@redhat.com>,
	<kvm@vger.kernel.org>, Markus Armbruster <armbru@redhat.com>, Eric Blake
	<eblake@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
Subject: Re: [PATCH] i386: revert defaults to 'legacy-vm-type=true' for
 SEV(-ES) guests
Message-ID: <za7dwgyz2yfspsivg67qkzkf4cz3eeiclavdznskap6zcip66s@7iqpll2pzax4>
References: <20240614103924.1420121-1-berrange@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240614103924.1420121-1-berrange@redhat.com>
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PEPF000042A8:EE_|BL3PR12MB6427:EE_
X-MS-Office365-Filtering-Correlation-Id: 3e7ce349-1389-4088-1180-08dc94b4e896
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230037|7416011|376011|36860700010|82310400023|1800799021;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?uYxClRXhsBwIXYbejILsIBcYKcMgLjDXYqRsc0ANYzFdU33Q34Drzsfx3N?=
 =?iso-8859-1?Q?xEYK/G/Gt0igHVO9ZrLbVNO3DWEOSKo9z0rUewFXpzFZbbdNC7Rd1WSxx/?=
 =?iso-8859-1?Q?9e1siUozU96gW3WRnMFTkse6+dx83URbi55jBnxUfwZPCfVATUZFv+b4io?=
 =?iso-8859-1?Q?XzLD89ar1OvugwNoYpg9RHvcxEQ4zOjNo4Z51vMNYhGIchMM3CuMD7HT93?=
 =?iso-8859-1?Q?gYsrXp3CoIzL0gt3jjgoCMc+IHTssDaMUEQ3JZpwVbzwd1/a2y7qBbs3Sw?=
 =?iso-8859-1?Q?jXqWssaCDZH0Mq8NipEtS+gdiYb5peoLgOPcBNNcgSGeiS4FY3V0VCCpfe?=
 =?iso-8859-1?Q?XaW3onsZW8UTLpvNzB3EbfMixhtYaGp8Xad2h0QwusFT/asKOepZUdY6P8?=
 =?iso-8859-1?Q?iB4qLWANPw5k5Xl/A3B+LUFnmjmsYNH/N1L14QopWeB1nmjgrONMPjWjNd?=
 =?iso-8859-1?Q?eSC7ah4AKFomd061gm6XBwBFAagxf1cbVnrJACqbQTvyWzYJKtzOYAooeE?=
 =?iso-8859-1?Q?6taYTN4mZMrOalHQVq7b1UJgefi1TQdNyjW2FqH4Acp/3lEoot9Og3QSvP?=
 =?iso-8859-1?Q?rI5bcD62JJlkKC+PY5fexAAp8Q4231sJpkrrTVk5ZlBmyEP6xoDoZDFMWG?=
 =?iso-8859-1?Q?tlk82/jigsjhZdinKNgovA9hAbS7yAgQoeLzX+ritL9QXJQHnqt4Fpvrar?=
 =?iso-8859-1?Q?NJFf+xMF+KgDU4cK0G/ZlFJz6XM5RTZrwTe4pHSA7tmlE1LgIsnrqBGJeo?=
 =?iso-8859-1?Q?dPEoIEFh9pS9lgKuHaVheEyp7iPnxbcJ5vl4UanYCXSXDwlY4C+uB13arz?=
 =?iso-8859-1?Q?pFYkRPBGlGtYQTwkKyWSOSDp/bUIedXX3dnyUGMx1EUiLW4sVEA9ydQ8Em?=
 =?iso-8859-1?Q?VPN/O5lyJaIzLjivf8VLv2MTMNVwJTw3qSsHWGnTdjz+u7gThtKNp31tzp?=
 =?iso-8859-1?Q?e8at9tEuJXJvGsr4gAvS8ZlhUYPgWFGvQJV0Ei/xG6hWICyMe4nx3Q+CSh?=
 =?iso-8859-1?Q?O0nEymHXBtsyy+gIApy+6sB1WDutKAU/mKPBcxOfYX343nQKTno3nEOMBP?=
 =?iso-8859-1?Q?89UntvMAjIdNLHalgiD904ufjJKWAaIOefUmfxuCMyx+C7/b8reefCgMww?=
 =?iso-8859-1?Q?YMDvkbOGNrY2THfND0oc3gm2lUjhGGiU8P67jh+MMwaGFGqbHUWdX2gTz1?=
 =?iso-8859-1?Q?jEeI3G4evk4a7Msi48DJ1GWO4Caa02hT1YxJ74VIDzuVMDcdXQOnG7LD4g?=
 =?iso-8859-1?Q?P8VrmIVoBn8DRmfpqkX5iV1DCsBKmW+S/rHHrj83u5PLGgQ4fAIzmUUlw0?=
 =?iso-8859-1?Q?3IXEawZsXf5u3hAik2xIBeNcXaN//RZLDpJUwRr0UYvzLThEzWDxLuopVr?=
 =?iso-8859-1?Q?4qpZmMIMp4lLicOmk7D0F5n60OXVxnQEy9RDcVhaTovEfgCAIr+VZfPDft?=
 =?iso-8859-1?Q?K2ZOqbNdG/TLuigqNNhqV8V6A7kgAm+eIEsiaw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230037)(7416011)(376011)(36860700010)(82310400023)(1800799021);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jun 2024 01:19:49.5222
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3e7ce349-1389-4088-1180-08dc94b4e896
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000042A8.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR12MB6427

On Fri, Jun 14, 2024 at 11:39:24AM +0100, Daniel P. Berrangé wrote:
> The KVM_SEV_INIT2 ioctl was only introduced in Linux 6.10, which will
> only have been released for a bit over a month when QEMU 9.1 is
> released.
> 
> The SEV(-ES) support in QEMU has been present since 2.12 dating back
> to 2018. With this in mind, the overwhealming majority of users of
> SEV(-ES) are unlikely to be running Linux >= 6.10, any time in the
> forseeable future.
> 
> IOW, defaulting new QEMU to 'legacy-vm-type=false' means latest QEMU
> machine types will be broken out of the box for most SEV(-ES) users.
> Even if the kernel is new enough, it also affects the guest measurement,
> which means that their existing tools for validating measurements will
> also be broken by the new default.
> 
> This is not a sensible default choice at this point in time. Revert to
> the historical behaviour which is compatible with what most users are
> currently running.

Part of the reason for the change is that SEV-ES measurements are
already affected by some short-comings of the legacy KVM_SEV_ES_INIT
API. Namely, if the kvm_amd.debug-swap module param is used to enable
that SEV-ES feature, then that feature will get enabled on the KVM side
and change the initial guest measurement (due to VMSA_FEATURES field
of the vCPU's VMSA changing), and userspace has no way to control that
on a per-VM basis, so measurement for any particular invocation will
be somewhat random depending on the system configuration and kernel
level.

I think that's why users of newer QEMU machine types are highly
encouraged to switch to the new KVM_SEV_INIT2 interface. I do see this
causing issues for older QEMU machine types that previously relied on
the legacy interface, since we do want to avoid measurement changing
for an existing guest that was previously working on an older kernel,
which is why this flag defaults to true for pre-9.1 machine types. But
on newer kernels there is still potential for issues relating to
debug-swap (and other VMSA features that get added to KVM in the future)
and how they may cause measurement changes underneath the covers if we
don't allow userspace the ability to control what is/isn't disabled.

Because of that I think it's less headache for userspace to have to
opt-in to legacy interface when using newer machine models. It should be
a concious decision to keep using this deprecated interface with known
limitations that could affect measurement in unexpected ways.

I was actually planning to go the other direction on this because
currently for 9.1+, QEMU will try to use KVM_SEV_INIT2 if
KVM_CAP_VM_TYPES advertises its availability, but otherwise fall back to
the above KVM_SEV_ES_INIT interface and potential inherit the issues
noted above. So I was planning on getting rid of the fallback, and
basically only allowing legacy KVM_SEV_ES_INIT for 9.1+ if the user
manually sets sev_guest->legacy_vm_type via cmdline.

-Mike

> 
> This can be re-evaluated a few years down the line, though it is more
> likely that all attention will be on SEV-SNP by this time. Distro
> vendors may still choose to change this default downstream to align
> with their new major releases where they can guarantee the kernel
> will always provide the required functionality.
> 
> Signed-off-by: Daniel P. Berrangé <berrange@redhat.com>
> ---
>  hw/i386/pc.c      |  1 -
>  qapi/qom.json     | 12 ++++++------
>  target/i386/sev.c |  7 +++++++
>  3 files changed, 13 insertions(+), 7 deletions(-)
> 
> diff --git a/hw/i386/pc.c b/hw/i386/pc.c
> index 0469af00a7..b65843c559 100644
> --- a/hw/i386/pc.c
> +++ b/hw/i386/pc.c
> @@ -82,7 +82,6 @@
>  GlobalProperty pc_compat_9_0[] = {
>      { TYPE_X86_CPU, "x-l1-cache-per-thread", "false" },
>      { TYPE_X86_CPU, "guest-phys-bits", "0" },
> -    { "sev-guest", "legacy-vm-type", "true" },
>      { TYPE_X86_CPU, "legacy-multi-node", "on" },
>  };
>  const size_t pc_compat_9_0_len = G_N_ELEMENTS(pc_compat_9_0);
> diff --git a/qapi/qom.json b/qapi/qom.json
> index 8bd299265e..714ebeec8b 100644
> --- a/qapi/qom.json
> +++ b/qapi/qom.json
> @@ -912,12 +912,12 @@
>  # @handle: SEV firmware handle (default: 0)
>  #
>  # @legacy-vm-type: Use legacy KVM_SEV_INIT KVM interface for creating the VM.
> -#                  The newer KVM_SEV_INIT2 interface syncs additional vCPU
> -#                  state when initializing the VMSA structures, which will
> -#                  result in a different guest measurement. Set this to
> -#                  maintain compatibility with older QEMU or kernel versions
> -#                  that rely on legacy KVM_SEV_INIT behavior.
> -#                  (default: false) (since 9.1)
> +#                  The newer KVM_SEV_INIT2 interface, from Linux >= 6.10, syncs
> +#                  additional vCPU state when initializing the VMSA structures,
> +#                  which will result in a different guest measurement. Toggle
> +#                  this to control compatibility with older QEMU or kernel
> +#                  versions that rely on legacy KVM_SEV_INIT behavior.
> +#                  (default: true) (since 9.1)
>  #
>  # Since: 2.12
>  ##
> diff --git a/target/i386/sev.c b/target/i386/sev.c
> index 004c667ac1..16029282b7 100644
> --- a/target/i386/sev.c
> +++ b/target/i386/sev.c
> @@ -2086,6 +2086,13 @@ sev_guest_instance_init(Object *obj)
>      object_property_add_uint32_ptr(obj, "policy", &sev_guest->policy,
>                                     OBJ_PROP_FLAG_READWRITE);
>      object_apply_compat_props(obj);
> +
> +    /*
> +     * KVM_SEV_INIT2 was only introduced in Linux 6.10. Avoid
> +     * breaking existing users of SEV, since the overwhealming
> +     * majority won't have a new enough kernel for a long time
> +     */
> +    sev_guest->legacy_vm_type = true;
>  }
>  
>  /* guest info specific sev/sev-es */
> -- 
> 2.45.1
> 

