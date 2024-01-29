Return-Path: <kvm+bounces-7393-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 287B684140B
	for <lists+kvm@lfdr.de>; Mon, 29 Jan 2024 21:11:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4CAA81C23F84
	for <lists+kvm@lfdr.de>; Mon, 29 Jan 2024 20:11:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F83676051;
	Mon, 29 Jan 2024 20:11:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="BF7e9mVn"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2087.outbound.protection.outlook.com [40.107.244.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81D2176023;
	Mon, 29 Jan 2024 20:11:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.87
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706559067; cv=fail; b=VnrTCoBGoPFB+Iogfj4g23Aku7rptuE6ALOHvPjXbtZSh3XDzrKAi6ZKjgsjDLxh2slNyeORJznqfHM2IkTZYoFaxvKwr4PiI6zeguMwMhizvZ0n+T/pNN5Sid7r7alLg4RHzJvgz1ZXzNmufLStr40/XGmNJFPcPeQYgo+FvH8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706559067; c=relaxed/simple;
	bh=/2QJpaTLmh0aFPoQsD8uMSVwvH5FFGm/sasgIfcGHno=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sBLAs739YDG2wkr6DTBSJtS2mu9HYUlbVhlSNI8j85jF4GJbCBdS5rAUisOYsZ+cpadeqLRPiDm+3lupoFoc0dRN7zTZ7qrTj5DEcM/djh0L36gTpyQ0MtJLBL/pTf1p7wafxphCQ+J+n1luqPvLGcxq3r3OUdLcCbwyzb/YN14=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=BF7e9mVn; arc=fail smtp.client-ip=40.107.244.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MMB6uYgtyo6Hn4QPbiTlNMS69fWyR0PGEZNOBcp11ZXuuEflwQfXW6ih9JFv9OiFpuDd4WKQQdrXd89LHJO4D2bEdyNLxkXPZ1IsZwQJ78LBp8tCKq1ZPoTKYju4qW0lL4vAhzlWB0XJC/t3zyGLWWaX3b5fKCnhDOaMabx4DEx98SyLfVe2dOEdNYliDV09Umr/degpK8Fuw6P/2IdXvtjCYSFwYNOOLBb670YJYmciJ82fKtLAs/8z+1DP1xuWpu4FGnu7cEVIaSXDkmtQg7H3sZXzLWlRUuv6k2hqKHoJW1sMrCFxOtZoZ1sJjzFkHITs60W12fh3THCLoF2Cpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FP2HbMCHGlfqGqtwHam1WgbNI/Scba3qLOcmTdHU/nY=;
 b=h88LLVqMu04SuftdFQaIXd1i0art5lFtvux627dGJLAeRiWVr6q2AVXJDSHjNQlDbqH98z4EscXrBFuaj335+h+kzGJq2p5TXGXKep+L8F/wyPm6r2dr+4J5nTYoMQh4K5DH0ENiva9OWwqfWrRKKso1VSM5P5fmop1ENUcCcyYIf1LBN9WicvN/fNkp0GjaAEUTRVrViPj6b4HxN9N9ppCd7jj0mSHhm35ASIuIhnteXaOp3q8j4IynGzXEbol5AtgkvONa81ERb5eCLwTSUL9Rjw9jNuQ760setWafBcXRHZHqQSeCYLeaGDpzQegQIEPa/gOXdr5oeahRF5qAYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=oracle.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FP2HbMCHGlfqGqtwHam1WgbNI/Scba3qLOcmTdHU/nY=;
 b=BF7e9mVnuLekXQxF7/ocIhqHgW5j+mg7M+CGgigflsqF1CFXgH/YObQHcdbPJOQ3t2gRCarZUWKf49Y7LI1mzrE7/6D6ZIfrL7w1V2gvgiDvOkgM1XmEjc8pHoW+F25g+AbPjEdrcMmdUCIaZy0ySpGgvcEpHahHhFp3Q2xvvs8=
Received: from MW4PR04CA0224.namprd04.prod.outlook.com (2603:10b6:303:87::19)
 by SA1PR12MB7319.namprd12.prod.outlook.com (2603:10b6:806:2b5::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7228.32; Mon, 29 Jan
 2024 20:11:02 +0000
Received: from MWH0EPF000989EC.namprd02.prod.outlook.com
 (2603:10b6:303:87:cafe::90) by MW4PR04CA0224.outlook.office365.com
 (2603:10b6:303:87::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7228.33 via Frontend
 Transport; Mon, 29 Jan 2024 20:11:02 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 MWH0EPF000989EC.mail.protection.outlook.com (10.167.241.139) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7249.19 via Frontend Transport; Mon, 29 Jan 2024 20:11:01 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.34; Mon, 29 Jan
 2024 14:11:00 -0600
Date: Mon, 29 Jan 2024 14:10:39 -0600
From: Michael Roth <michael.roth@amd.com>
To: Liam Merwick <liam.merwick@oracle.com>
CC: "x86@kernel.org" <x86@kernel.org>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"tglx@linutronix.de" <tglx@linutronix.de>, "mingo@redhat.com"
	<mingo@redhat.com>, "jroedel@suse.de" <jroedel@suse.de>,
	"thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "hpa@zytor.com"
	<hpa@zytor.com>, "ardb@kernel.org" <ardb@kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "seanjc@google.com" <seanjc@google.com>,
	"vkuznets@redhat.com" <vkuznets@redhat.com>, "jmattson@google.com"
	<jmattson@google.com>, "luto@kernel.org" <luto@kernel.org>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "slp@redhat.com"
	<slp@redhat.com>, "pgonda@google.com" <pgonda@google.com>,
	"peterz@infradead.org" <peterz@infradead.org>,
	"srinivas.pandruvada@linux.intel.com" <srinivas.pandruvada@linux.intel.com>,
	"rientjes@google.com" <rientjes@google.com>, "tobin@ibm.com" <tobin@ibm.com>,
	"bp@alien8.de" <bp@alien8.de>, "vbabka@suse.cz" <vbabka@suse.cz>,
	"kirill@shutemov.name" <kirill@shutemov.name>, "ak@linux.intel.com"
	<ak@linux.intel.com>, "tony.luck@intel.com" <tony.luck@intel.com>,
	"sathyanarayanan.kuppuswamy@linux.intel.com"
	<sathyanarayanan.kuppuswamy@linux.intel.com>, "alpergun@google.com"
	<alpergun@google.com>, "jarkko@kernel.org" <jarkko@kernel.org>,
	"ashish.kalra@amd.com" <ashish.kalra@amd.com>, "nikunj.dadhania@amd.com"
	<nikunj.dadhania@amd.com>, "pankaj.gupta@amd.com" <pankaj.gupta@amd.com>,
	Brijesh Singh <brijesh.singh@amd.com>, Alexey Kardashevskiy <aik@amd.com>,
	Dionna Glaze <dionnaglaze@google.com>
Subject: Re: [PATCH v2 25/25] crypto: ccp: Add the SNP_SET_CONFIG command
Message-ID: <20240129201039.7gi3o3tfuvimycye@amd.com>
References: <20240126041126.1927228-1-michael.roth@amd.com>
 <20240126041126.1927228-26-michael.roth@amd.com>
 <57750667-92a2-4510-99fa-af7df8d887fc@oracle.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <57750667-92a2-4510-99fa-af7df8d887fc@oracle.com>
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWH0EPF000989EC:EE_|SA1PR12MB7319:EE_
X-MS-Office365-Filtering-Correlation-Id: 5ef9ecf0-e620-4d60-0e7d-08dc21066a82
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	IohQ03/Ydga1+YGtR/K04IHgb1m9b5sq0KPoIjOV2vyI9odaUaoENczXQxVx8lc3nScx9gI2dlxnJ+D75BkOROpYpFKFU+696txFSzahsdKMUOCZAF9C6J+RG2u6x4Mpg+ChIKgttVEDu8YPIWl0Bvmbn8MSn2wVjBjYW4RjlcmU21GeECJjK2R0SxwBrWDMtE6ijdXIS0Dg5hbaEg2/J7+9A0YSYF+lQpDAzfmkUaAXvWvc7ocD1okGxwwmAU2aSopse7MHpjwdJdrsxuWjUxbRrPItu63tX9OBAJKr5AQB1jnRZtkazRehQkyM5WPHT/Aj0CJle8R/hSEtW1Xw0OihTpVWDIgbIfJ5NxxGZOgk8RSDosuPWdCImxD8gk1GZp4/r3hojxeD65JHqxYoy0R6rx+wHomX7GR3GQ+NBNqDlh6r5Tvd6l7FBvMwW3wCS4DOwNY3HV7GkQlVyRDwDHsjl6Q4oyRcqslJgU4N+Qc/7UVNNsTtO8ALYb5m6iHpqlZJEvT6zMEEtyh2t41uSbGsnc1zRdiDoJy4dbZRqTxcekAbfvquac/Zz6a2zTpD3pBF1AIRW7gAH03XN7mG1Uxslk5wu2P38JfzPR7fq/f2Jv0fymnkqsQnDkD0+SzrV4hLjmNTjlaOpogvvSHj3ySHHs4OkZd0CS8AGOQvBui0fo9ztCPL9p9LwT9w4r3SKo3n4REXYzpDoIeCXnsh5vOGAZIXsqoCH13fJms68L0AXV/TeGhH68xr1CvHe2dYfMD8zmSwKVRAylHuwTMT3A==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(136003)(346002)(376002)(396003)(39860400002)(230922051799003)(82310400011)(1800799012)(186009)(64100799003)(451199024)(46966006)(40470700004)(36840700001)(40460700003)(40480700001)(16526019)(426003)(83380400001)(6666004)(336012)(53546011)(1076003)(36756003)(86362001)(82740400003)(26005)(356005)(81166007)(44832011)(8676002)(8936002)(41300700001)(4326008)(5660300002)(36860700001)(478600001)(316002)(47076005)(70206006)(6916009)(54906003)(7406005)(7416002)(966005)(2616005)(2906002)(70586007)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jan 2024 20:11:01.8477
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5ef9ecf0-e620-4d60-0e7d-08dc21066a82
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000989EC.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB7319

On Mon, Jan 29, 2024 at 07:18:54PM +0000, Liam Merwick wrote:
> On 26/01/2024 04:11, Michael Roth wrote:
> > From: Brijesh Singh <brijesh.singh@amd.com>
> > 
> > The SEV-SNP firmware provides the SNP_CONFIG command used to set various
> > system-wide configuration values for SNP guests, such as the reported
> > TCB version used when signing guest attestation reports. Add an
> > interface to set this via userspace.
> > 
> > Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> > Co-developed-by: Alexey Kardashevskiy <aik@amd.com>
> > Signed-off-by: Alexey Kardashevskiy <aik@amd.com>
> > Co-developed-by: Dionna Glaze <dionnaglaze@google.com>
> > Signed-off-by: Dionna Glaze <dionnaglaze@google.com>
> > Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> > [mdr: squash in doc patch from Dionna, drop extended request/certificate
> >   handling and simplify this to a simple wrapper around SNP_CONFIG fw
> >   cmd]
> > Signed-off-by: Michael Roth <michael.roth@amd.com>
> > ---
> >   Documentation/virt/coco/sev-guest.rst | 13 +++++++++++++
> >   drivers/crypto/ccp/sev-dev.c          | 20 ++++++++++++++++++++
> >   include/uapi/linux/psp-sev.h          |  1 +
> >   3 files changed, 34 insertions(+)
> > 
> > diff --git a/Documentation/virt/coco/sev-guest.rst b/Documentation/virt/coco/sev-guest.rst
> > index 007ae828aa2a..14c9de997b7d 100644
> > --- a/Documentation/virt/coco/sev-guest.rst
> > +++ b/Documentation/virt/coco/sev-guest.rst
> > @@ -162,6 +162,19 @@ SEV-SNP firmware SNP_COMMIT command. This prevents roll-back to a previously
> >   committed firmware version. This will also update the reported TCB to match
> >   that of the currently installed firmware.
> >   
> > +2.6 SNP_SET_CONFIG
> > +------------------
> > +:Technology: sev-snp
> > +:Type: hypervisor ioctl cmd
> > +:Parameters (in): struct sev_user_data_snp_config
> > +:Returns (out): 0 on success, -negative on error
> > +
> > +SNP_SET_CONFIG is used to set the system-wide configuration such as
> > +reported TCB version in the attestation report. The command is similar
> > +to SNP_CONFIG command defined in the SEV-SNP spec. The current values of
> > +the firmware parameters affected by this command can be queried via
> > +SNP_PLATFORM_STATUS.
> > +
> >   3. SEV-SNP CPUID Enforcement
> >   ============================
> >   
> > diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
> > index 73ace4064e5a..398ae932aa0b 100644
> > --- a/drivers/crypto/ccp/sev-dev.c
> > +++ b/drivers/crypto/ccp/sev-dev.c
> > @@ -1982,6 +1982,23 @@ static int sev_ioctl_do_snp_commit(struct sev_issue_cmd *argp)
> >   	return __sev_do_cmd_locked(SEV_CMD_SNP_COMMIT, &buf, &argp->error);
> >   }
> >   
> > +static int sev_ioctl_do_snp_set_config(struct sev_issue_cmd *argp, bool writable)
> > +{
> > +	struct sev_device *sev = psp_master->sev_data;
> 
> Should this check that psp_master is not NULL? Like the fix for
> https://lore.kernel.org/all/20240125231253.3122579-1-kim.phillips@amd.com/

It wouldn't hurt, but sev_ioctl() will check for it before getting here,
so I don't think it's a reachable condition.

There's a number of spots where existing SEV/legacy code relies on
psp_pci_init() always setting psp_master before sev_pci_init(). Kim's
patch fixes 1 exception that's reachable if you synthetically force a
driver remove via DEBUG_TEST_DRIVER_REMOVE before the psp_pci_init()
call is made during probe, which generally wouldn't happen in practice.

But there may be other cases like the one Kim hit where "not work"
isn't handled gracefully. Fortunately the other obvious spot,
sev_do_cmd(), also checks for !psp_master, so that covers most of the
internal users of sev-dev.c.

But a general cleanup to introduce a helper like get_sev_device() that
handles !psp_master might be a nice follow-up to make things more
robust.

-Mike

> 
> Otherwise,
> Reviewed-by: Liam Merwick <liam.merwick@oracle.com>
> 
> > +	struct sev_user_data_snp_config config;
> > +
> > +	if (!sev->snp_initialized || !argp->data)
> > +		return -EINVAL;
> > +
> > +	if (!writable)
> > +		return -EPERM;
> > +
> > +	if (copy_from_user(&config, (void __user *)argp->data, sizeof(config)))
> > +		return -EFAULT;
> > +
> > +	return __sev_do_cmd_locked(SEV_CMD_SNP_CONFIG, &config, &argp->error);
> > +}
> > +
> >   static long sev_ioctl(struct file *file, unsigned int ioctl, unsigned long arg)
> >   {
> >   	void __user *argp = (void __user *)arg;
> > @@ -2039,6 +2056,9 @@ static long sev_ioctl(struct file *file, unsigned int ioctl, unsigned long arg)
> >   	case SNP_COMMIT:
> >   		ret = sev_ioctl_do_snp_commit(&input);
> >   		break;
> > +	case SNP_SET_CONFIG:
> > +		ret = sev_ioctl_do_snp_set_config(&input, writable);
> > +		break;
> >   	default:
> >   		ret = -EINVAL;
> >   		goto out;
> > diff --git a/include/uapi/linux/psp-sev.h b/include/uapi/linux/psp-sev.h
> > index 35c207664e95..b7a2c2ee35b7 100644
> > --- a/include/uapi/linux/psp-sev.h
> > +++ b/include/uapi/linux/psp-sev.h
> > @@ -30,6 +30,7 @@ enum {
> >   	SEV_GET_ID2,
> >   	SNP_PLATFORM_STATUS,
> >   	SNP_COMMIT,
> > +	SNP_SET_CONFIG,
> >   
> >   	SEV_MAX,
> >   };
> 

