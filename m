Return-Path: <kvm+bounces-7141-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 9892F83DB13
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 14:39:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0C8F31F2596C
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 13:39:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2FA101BDCC;
	Fri, 26 Jan 2024 13:39:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="k78jvNeG"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2046.outbound.protection.outlook.com [40.107.95.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 412771B943;
	Fri, 26 Jan 2024 13:39:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.95.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706276349; cv=fail; b=fHEEl/E561LbBeGwZurCugUv6O4T03o1FKALBmVw/ZIwWEB5txC1gYTORyZuEi4dh6rpK3QaqaFRYhLMagbQ6R12CGvbRmi+Zj3PiQrFaonbTeGi8BFh+yQNnZpB0+tEQaeH+85RAzE5GLRew29vyp95lVY6xG1P7YPEEu9NHzU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706276349; c=relaxed/simple;
	bh=hk2skbM7BuyHbPf7zcDkXcZjD3pbnqdbsIRrA3CWwi4=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Aj9mlIEb9RngbjmO8fNfZsC/cDkvYHIeighy2wZXcCuSI1tX4KzkjxdHsRKmNt1Dsas94I0ERSGy18YZ0ytPf+Cn+/ker4QbCoxSMF+KVHSgrXhL6ful7VIybKm85yCdFoZDHxTbiGJYZl64pMlmguX2/5CI5iz9y+N7nPR2+XI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=k78jvNeG; arc=fail smtp.client-ip=40.107.95.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TH7dLCYZQJLI2b7iZVOPMfCplcndFf1Az20mHCz24J4RFBXIOJlOaWPHQXLNLPBiKRNFUu+Y5xNFc0ZTkxiVwv9DasQI4DvwdStvqCPxfiBgxboNrIYsiKNEyqQQgOpkpFmUmDeErUnzPej/fEDQZuiWzw2ilWdN25T+HnYMGt2ZLpuSkct4P5l150mo6R4C69sCHaoFFaRWMjLa1bAr80RNYywkNYsIl8L5KyJzDbjmeB56uiQXPgFqkEPHYXHzlIT4RGXj6oG8rqieAY1OJpAD4curgQ4S+4FKIiGyR05aSMqt/IHc2VCsdDOQQmGfgep+yS90opHo8MJW2+KhZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XL9QPbD+Asy5bQfLdpRU1HXWgoykASx0PBZ83d7MMDU=;
 b=Kv/qVxE5G/8BiAxCFF59czUWfxDr3LHDGrNhNyfo79F5RsNlzJfmb7AEAbx8KTC1l8Hcz3HiZYFGdC4+YmwisnF62YcbnaYlM0wunXZMPvFFXgFMH+aAINoCN6wr8xONm02KHWky0KkuEFIlBjux+HMEDLCYIl49bpQIQtzCyXoUFH7W5cH+ZAWv41U0eqRRfx290alaJoNIJstqI7EZaiYcQUbh/RO/ZVb1KOgxyvmlbZsDsYZjdqMkIk2YwFsKTK1aLjnPRUAoCHbkHqwXtIFCLu0cq94Wuo4hKMQHsawfNWOLX7tIumuD5N/DajH7imYbnoW+U1zBeIRUVtsICg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=alien8.de smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XL9QPbD+Asy5bQfLdpRU1HXWgoykASx0PBZ83d7MMDU=;
 b=k78jvNeGT7pXI1VFBZc1aVG0h1OQFJ07SY3iyl137pLeG4BcMldQq/81c4yRwXC6XzwofXSe1Db2iQKeYqYbOvU4Lh/1Oq3ABaSP/uDGo46q7m/aC1BdTS6RnQXOKjGKo+ZWwDNLIhb/qO5HNiwguUrxzqt2HK7czdgkC2Sr4f8=
Received: from BN9PR03CA0298.namprd03.prod.outlook.com (2603:10b6:408:f5::33)
 by SA1PR12MB8948.namprd12.prod.outlook.com (2603:10b6:806:38e::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7228.26; Fri, 26 Jan
 2024 13:39:04 +0000
Received: from BN1PEPF0000468A.namprd05.prod.outlook.com
 (2603:10b6:408:f5:cafe::9c) by BN9PR03CA0298.outlook.office365.com
 (2603:10b6:408:f5::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7228.27 via Frontend
 Transport; Fri, 26 Jan 2024 13:39:04 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN1PEPF0000468A.mail.protection.outlook.com (10.167.243.135) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7228.16 via Frontend Transport; Fri, 26 Jan 2024 13:39:03 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.34; Fri, 26 Jan
 2024 07:39:02 -0600
Date: Fri, 26 Jan 2024 07:29:02 -0600
From: Michael Roth <michael.roth@amd.com>
To: Borislav Petkov <bp@alien8.de>
CC: <x86@kernel.org>, <kvm@vger.kernel.org>, <linux-coco@lists.linux.dev>,
	<linux-mm@kvack.org>, <linux-crypto@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <tglx@linutronix.de>, <mingo@redhat.com>,
	<jroedel@suse.de>, <thomas.lendacky@amd.com>, <hpa@zytor.com>,
	<ardb@kernel.org>, <pbonzini@redhat.com>, <seanjc@google.com>,
	<vkuznets@redhat.com>, <jmattson@google.com>, <luto@kernel.org>,
	<dave.hansen@linux.intel.com>, <slp@redhat.com>, <pgonda@google.com>,
	<peterz@infradead.org>, <srinivas.pandruvada@linux.intel.com>,
	<rientjes@google.com>, <tobin@ibm.com>, <vbabka@suse.cz>,
	<kirill@shutemov.name>, <ak@linux.intel.com>, <tony.luck@intel.com>,
	<sathyanarayanan.kuppuswamy@linux.intel.com>, <alpergun@google.com>,
	<jarkko@kernel.org>, <ashish.kalra@amd.com>, <nikunj.dadhania@amd.com>,
	<pankaj.gupta@amd.com>, <liam.merwick@oracle.com>
Subject: Re: [PATCH v1 18/26] crypto: ccp: Handle legacy SEV commands when
 SNP is enabled
Message-ID: <20240126132902.p7f6xbg6ru3btsfo@amd.com>
References: <20231230161954.569267-1-michael.roth@amd.com>
 <20231230161954.569267-19-michael.roth@amd.com>
 <20240119171816.GKZaqu2M_1Pu7Q4mBn@fat_crate.local>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20240119171816.GKZaqu2M_1Pu7Q4mBn@fat_crate.local>
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN1PEPF0000468A:EE_|SA1PR12MB8948:EE_
X-MS-Office365-Filtering-Correlation-Id: 1f209bbf-53b1-4e78-1045-08dc1e742917
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	Z6sQfN+7MFVPiAQVEImmgB1JjEgk6FXm7kZ/mNQ+2ZxjGh3F6WYIhPzBShtT12BhttIAPVoE0VltVfv+UEa6kbiwca4sBYDKIrxS9tkvOfcoSSN7ooz8a36Q+40p440kGX+6Lc8A4zx6HFVGo/+PcYgnl2yv9mPrha70aCoLsM4snworUUjTPB2TaPTCZbt1A9UFCbkf0Twt5FLk60rO/7F6/eKGpt47NYoPuKna+2OY/N4nRg6nV8J74QmAPcnDBLvclNxxSa7VMnsp4k8fiK4tZAMXGHSolYDYxLePWMrOSf895mM+9pV5oPw2z1thz3Xz3l5HVAGCVY21Ual7hp0+I2cXsAs0h3KMUIdHnCH+3BGozFt8IpzyI16krUXKrfeMPlYBVXgGLOj9LalFrXyN3HROwUiuMwNoO+yNO1gPisL/F/T+YjeP4FjFl57j6T1IjhV9DeE9FmUU/QFGW45/5r5xxCVSm6LpIlHuukCgzf0OhL+qM3YTnUcOsREWd8qov8XNFR/iX8DKOaTMD9Z7QmewFTu02vCtq+NAC0ZaWcDYzvYXL4qJXIRzXuUeLBoQfBo3MZhSpi6V54t3pNLephtRojWu9GaCYggBcyOPhJS/PHXzdKz47i3X3bRwvHedfEHzbKFlpPVslx7HNIyeqF58G16O+cOY6M4d2oRvZQczCm69b1YM8yh1Xz/h90Z5vEEO2hV9UKYhrG6AMCSrKspZLYyIMFeddKyDNo7wm7GwvyOa++G319Qs9i/uaNU2PEiC+8T8j0jovE3Jgw==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(396003)(136003)(39860400002)(376002)(346002)(230922051799003)(186009)(64100799003)(82310400011)(451199024)(1800799012)(46966006)(40470700004)(36840700001)(8936002)(7406005)(4326008)(8676002)(70586007)(7416002)(2906002)(5660300002)(30864003)(44832011)(70206006)(86362001)(316002)(36756003)(54906003)(478600001)(966005)(6916009)(36860700001)(47076005)(82740400003)(356005)(81166007)(83380400001)(26005)(2616005)(1076003)(426003)(336012)(41300700001)(40480700001)(40460700003)(16526019)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2024 13:39:03.3559
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1f209bbf-53b1-4e78-1045-08dc1e742917
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN1PEPF0000468A.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB8948

On Fri, Jan 19, 2024 at 06:18:30PM +0100, Borislav Petkov wrote:
> On Sat, Dec 30, 2023 at 10:19:46AM -0600, Michael Roth wrote:
> > From: Brijesh Singh <brijesh.singh@amd.com>
> > 
> > The behavior of legacy SEV commands is altered when the firmware is
> > initialized for SNP support. In that case, all command buffer memory
> > that may get written to by legacy SEV commands must be marked as
> > firmware-owned in the RMP table prior to issuing the command.
> > 
> > Additionally, when a command buffer contains a system physical address
> > that points to additional buffers that firmware may write to, special
> > handling is needed depending on whether:
> > 
> >   1) the system physical address points to guest memory
> >   2) the system physical address points to host memory
> > 
> > To handle case #1, the pages of these buffers are changed to
> > firmware-owned in the RMP table before issuing the command, and restored
> > to after the command completes.
> > 
> > For case #2, a bounce buffer is used instead of the original address.
> > 
> > Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> > Co-developed-by: Michael Roth <michael.roth@amd.com>
> > Signed-off-by: Michael Roth <michael.roth@amd.com>
> > Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> > ---
> >  drivers/crypto/ccp/sev-dev.c | 421 ++++++++++++++++++++++++++++++++++-
> >  drivers/crypto/ccp/sev-dev.h |   3 +
> >  2 files changed, 414 insertions(+), 10 deletions(-)
> 
> Definitely better, thanks.
> 
> Some cleanups ontop:
> 
> ---
> 
> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
> index 8cfb376ca2e7..7681c094c7ff 100644
> --- a/drivers/crypto/ccp/sev-dev.c
> +++ b/drivers/crypto/ccp/sev-dev.c
> @@ -514,18 +514,21 @@ static void *sev_fw_alloc(unsigned long len)
>   * struct cmd_buf_desc - descriptors for managing legacy SEV command address
>   * parameters corresponding to buffers that may be written to by firmware.
>   *
> - * @paddr_ptr: pointer the address parameter in the command buffer, which may
> - *	need to be saved/restored depending on whether a bounce buffer is used.
> - *	Must be NULL if this descriptor is only an end-of-list indicator.
> + * @paddr: address which may need to be saved/restored depending on whether
> + * a bounce buffer is used. Must be NULL if this descriptor is only an
> + * end-of-list indicator.
> + *
>   * @paddr_orig: storage for the original address parameter, which can be used to
> - *	restore the original value in @paddr_ptr in cases where it is replaced
> - *	with the address of a bounce buffer.
> - * @len: length of buffer located at the address originally stored at @paddr_ptr
> + * restore the original value in @paddr in cases where it is replaced with
> + * the address of a bounce buffer.
> + *
> + * @len: length of buffer located at the address originally stored at @paddr
> + *
>   * @guest_owned: true if the address corresponds to guest-owned pages, in which
> - *	case bounce buffers are not needed.
> + * case bounce buffers are not needed.

In v2 I've fixed up the alignments in accordance with
Documentation/doc-guide/kernel-doc.rst, which asks for the starting column of
a multi-line description to be the same as first line, and asked for newlines
to not be inserted in between parameters/members. I've gone back and updated
other occurences in the series as well.

>   */
>  struct cmd_buf_desc {
> -	u64 *paddr_ptr;
> +	u64 paddr;

Unfortunately the logic here doesn't really work with this approach. If
a descriptor needs to be re-mapped to a bounce buffer, the command
buffer that contains the original address of the buffer needs to be
updated to point to it, so that's where the pointer comes into play, so
I've kept this in place for v2, but worked on all your other
suggestions.

Thanks,

Mike

>  	u64 paddr_orig;
>  	u32 len;
>  	bool guest_owned;
> @@ -549,30 +552,30 @@ static void snp_populate_cmd_buf_desc_list(int cmd, void *cmd_buf,
>  	case SEV_CMD_PDH_CERT_EXPORT: {
>  		struct sev_data_pdh_cert_export *data = cmd_buf;
> 
> -		desc_list[0].paddr_ptr = &data->pdh_cert_address;
> +		desc_list[0].paddr = data->pdh_cert_address;
>  		desc_list[0].len = data->pdh_cert_len;
> -		desc_list[1].paddr_ptr = &data->cert_chain_address;
> +		desc_list[1].paddr = data->cert_chain_address;
>  		desc_list[1].len = data->cert_chain_len;
>  		break;
>  	}
>  	case SEV_CMD_GET_ID: {
>  		struct sev_data_get_id *data = cmd_buf;
> 
> -		desc_list[0].paddr_ptr = &data->address;
> +		desc_list[0].paddr = data->address;
>  		desc_list[0].len = data->len;
>  		break;
>  	}
>  	case SEV_CMD_PEK_CSR: {
>  		struct sev_data_pek_csr *data = cmd_buf;
> 
> -		desc_list[0].paddr_ptr = &data->address;
> +		desc_list[0].paddr = data->address;
>  		desc_list[0].len = data->len;
>  		break;
>  	}
>  	case SEV_CMD_LAUNCH_UPDATE_DATA: {
>  		struct sev_data_launch_update_data *data = cmd_buf;
> 
> -		desc_list[0].paddr_ptr = &data->address;
> +		desc_list[0].paddr = data->address;
>  		desc_list[0].len = data->len;
>  		desc_list[0].guest_owned = true;
>  		break;
> @@ -580,7 +583,7 @@ static void snp_populate_cmd_buf_desc_list(int cmd, void *cmd_buf,
>  	case SEV_CMD_LAUNCH_UPDATE_VMSA: {
>  		struct sev_data_launch_update_vmsa *data = cmd_buf;
> 
> -		desc_list[0].paddr_ptr = &data->address;
> +		desc_list[0].paddr = data->address;
>  		desc_list[0].len = data->len;
>  		desc_list[0].guest_owned = true;
>  		break;
> @@ -588,14 +591,14 @@ static void snp_populate_cmd_buf_desc_list(int cmd, void *cmd_buf,
>  	case SEV_CMD_LAUNCH_MEASURE: {
>  		struct sev_data_launch_measure *data = cmd_buf;
> 
> -		desc_list[0].paddr_ptr = &data->address;
> +		desc_list[0].paddr = data->address;
>  		desc_list[0].len = data->len;
>  		break;
>  	}
>  	case SEV_CMD_LAUNCH_UPDATE_SECRET: {
>  		struct sev_data_launch_secret *data = cmd_buf;
> 
> -		desc_list[0].paddr_ptr = &data->guest_address;
> +		desc_list[0].paddr = data->guest_address;
>  		desc_list[0].len = data->guest_len;
>  		desc_list[0].guest_owned = true;
>  		break;
> @@ -603,7 +606,7 @@ static void snp_populate_cmd_buf_desc_list(int cmd, void *cmd_buf,
>  	case SEV_CMD_DBG_DECRYPT: {
>  		struct sev_data_dbg *data = cmd_buf;
> 
> -		desc_list[0].paddr_ptr = &data->dst_addr;
> +		desc_list[0].paddr = data->dst_addr;
>  		desc_list[0].len = data->len;
>  		desc_list[0].guest_owned = true;
>  		break;
> @@ -611,7 +614,7 @@ static void snp_populate_cmd_buf_desc_list(int cmd, void *cmd_buf,
>  	case SEV_CMD_DBG_ENCRYPT: {
>  		struct sev_data_dbg *data = cmd_buf;
> 
> -		desc_list[0].paddr_ptr = &data->dst_addr;
> +		desc_list[0].paddr = data->dst_addr;
>  		desc_list[0].len = data->len;
>  		desc_list[0].guest_owned = true;
>  		break;
> @@ -619,39 +622,39 @@ static void snp_populate_cmd_buf_desc_list(int cmd, void *cmd_buf,
>  	case SEV_CMD_ATTESTATION_REPORT: {
>  		struct sev_data_attestation_report *data = cmd_buf;
> 
> -		desc_list[0].paddr_ptr = &data->address;
> +		desc_list[0].paddr = data->address;
>  		desc_list[0].len = data->len;
>  		break;
>  	}
>  	case SEV_CMD_SEND_START: {
>  		struct sev_data_send_start *data = cmd_buf;
> 
> -		desc_list[0].paddr_ptr = &data->session_address;
> +		desc_list[0].paddr = data->session_address;
>  		desc_list[0].len = data->session_len;
>  		break;
>  	}
>  	case SEV_CMD_SEND_UPDATE_DATA: {
>  		struct sev_data_send_update_data *data = cmd_buf;
> 
> -		desc_list[0].paddr_ptr = &data->hdr_address;
> +		desc_list[0].paddr = data->hdr_address;
>  		desc_list[0].len = data->hdr_len;
> -		desc_list[1].paddr_ptr = &data->trans_address;
> +		desc_list[1].paddr = data->trans_address;
>  		desc_list[1].len = data->trans_len;
>  		break;
>  	}
>  	case SEV_CMD_SEND_UPDATE_VMSA: {
>  		struct sev_data_send_update_vmsa *data = cmd_buf;
> 
> -		desc_list[0].paddr_ptr = &data->hdr_address;
> +		desc_list[0].paddr = data->hdr_address;
>  		desc_list[0].len = data->hdr_len;
> -		desc_list[1].paddr_ptr = &data->trans_address;
> +		desc_list[1].paddr = data->trans_address;
>  		desc_list[1].len = data->trans_len;
>  		break;
>  	}
>  	case SEV_CMD_RECEIVE_UPDATE_DATA: {
>  		struct sev_data_receive_update_data *data = cmd_buf;
> 
> -		desc_list[0].paddr_ptr = &data->guest_address;
> +		desc_list[0].paddr = data->guest_address;
>  		desc_list[0].len = data->guest_len;
>  		desc_list[0].guest_owned = true;
>  		break;
> @@ -659,7 +662,7 @@ static void snp_populate_cmd_buf_desc_list(int cmd, void *cmd_buf,
>  	case SEV_CMD_RECEIVE_UPDATE_VMSA: {
>  		struct sev_data_receive_update_vmsa *data = cmd_buf;
> 
> -		desc_list[0].paddr_ptr = &data->guest_address;
> +		desc_list[0].paddr = data->guest_address;
>  		desc_list[0].len = data->guest_len;
>  		desc_list[0].guest_owned = true;
>  		break;
> @@ -687,16 +690,16 @@ static int snp_map_cmd_buf_desc(struct cmd_buf_desc *desc)
>  			return -ENOMEM;
>  		}
> 
> -		desc->paddr_orig = *desc->paddr_ptr;
> -		*desc->paddr_ptr = __psp_pa(page_to_virt(page));
> +		desc->paddr_orig = desc->paddr;
> +		desc->paddr = __psp_pa(page_to_virt(page));
>  	}
> 
> -	paddr = *desc->paddr_ptr;
> +	paddr = desc->paddr;
>  	npages = PAGE_ALIGN(desc->len) >> PAGE_SHIFT;
> 
>  	/* Transition the buffer to firmware-owned. */
>  	if (rmp_mark_pages_firmware(paddr, npages, true)) {
> -		pr_warn("Failed move pages to firmware-owned state for SEV legacy command.\n");
> +		pr_warn("Error moving pages to firmware-owned state for SEV legacy command.\n");
>  		return -EFAULT;
>  	}
> 
> @@ -705,31 +708,29 @@ static int snp_map_cmd_buf_desc(struct cmd_buf_desc *desc)
> 
>  static int snp_unmap_cmd_buf_desc(struct cmd_buf_desc *desc)
>  {
> -	unsigned long paddr;
>  	unsigned int npages;
> 
>  	if (!desc->len)
>  		return 0;
> 
> -	paddr = *desc->paddr_ptr;
>  	npages = PAGE_ALIGN(desc->len) >> PAGE_SHIFT;
> 
>  	/* Transition the buffers back to hypervisor-owned. */
> -	if (snp_reclaim_pages(paddr, npages, true)) {
> +	if (snp_reclaim_pages(desc->paddr, npages, true)) {
>  		pr_warn("Failed to reclaim firmware-owned pages while issuing SEV legacy command.\n");
>  		return -EFAULT;
>  	}
> 
>  	/* Copy data from bounce buffer and then free it. */
>  	if (!desc->guest_owned) {
> -		void *bounce_buf = __va(__sme_clr(paddr));
> +		void *bounce_buf = __va(__sme_clr(desc->paddr));
>  		void *dst_buf = __va(__sme_clr(desc->paddr_orig));
> 
>  		memcpy(dst_buf, bounce_buf, desc->len);
>  		__free_pages(virt_to_page(bounce_buf), get_order(desc->len));
> 
>  		/* Restore the original address in the command buffer. */
> -		*desc->paddr_ptr = desc->paddr_orig;
> +		desc->paddr = desc->paddr_orig;
>  	}
> 
>  	return 0;
> @@ -737,14 +738,14 @@ static int snp_unmap_cmd_buf_desc(struct cmd_buf_desc *desc)
> 
>  static int snp_map_cmd_buf_desc_list(int cmd, void *cmd_buf, struct cmd_buf_desc *desc_list)
>  {
> -	int i, n;
> +	int i;
> 
>  	snp_populate_cmd_buf_desc_list(cmd, cmd_buf, desc_list);
> 
>  	for (i = 0; i < CMD_BUF_DESC_MAX; i++) {
>  		struct cmd_buf_desc *desc = &desc_list[i];
> 
> -		if (!desc->paddr_ptr)
> +		if (!desc->paddr)
>  			break;
> 
>  		if (snp_map_cmd_buf_desc(desc))
> @@ -754,8 +755,7 @@ static int snp_map_cmd_buf_desc_list(int cmd, void *cmd_buf, struct cmd_buf_desc
>  	return 0;
> 
>  err_unmap:
> -	n = i;
> -	for (i = 0; i < n; i++)
> +	for (i--; i >= 0; i--)
>  		snp_unmap_cmd_buf_desc(&desc_list[i]);
> 
>  	return -EFAULT;
> @@ -768,7 +768,7 @@ static int snp_unmap_cmd_buf_desc_list(struct cmd_buf_desc *desc_list)
>  	for (i = 0; i < CMD_BUF_DESC_MAX; i++) {
>  		struct cmd_buf_desc *desc = &desc_list[i];
> 
> -		if (!desc->paddr_ptr)
> +		if (!desc->paddr)
>  			break;
> 
>  		if (snp_unmap_cmd_buf_desc(desc))
> @@ -799,8 +799,8 @@ static bool sev_cmd_buf_writable(int cmd)
>  	}
>  }
> 
> -/* After SNP is INIT'ed, the behavior of legacy SEV commands is changed. */
> -static bool snp_legacy_handling_needed(int cmd)
> +/* After SNP is initialized, the behavior of legacy SEV commands is changed. */
> +static inline bool snp_legacy_handling_needed(int cmd)
>  {
>  	struct sev_device *sev = psp_master->sev_data;
> 
> @@ -891,7 +891,7 @@ static int __sev_do_cmd_locked(int cmd, void *data, int *psp_ret)
>  			sev->cmd_buf_backup_active = true;
>  		} else {
>  			dev_err(sev->dev,
> -				"SEV: too many firmware commands are in-progress, no command buffers available.\n");
> +				"SEV: too many firmware commands in progress, no command buffers available.\n");
>  			return -EBUSY;
>  		}
> 
> @@ -904,7 +904,7 @@ static int __sev_do_cmd_locked(int cmd, void *data, int *psp_ret)
>  		ret = snp_prep_cmd_buf(cmd, cmd_buf, desc_list);
>  		if (ret) {
>  			dev_err(sev->dev,
> -				"SEV: failed to prepare buffer for legacy command %#x. Error: %d\n",
> +				"SEV: failed to prepare buffer for legacy command 0x%#x. Error: %d\n",
>  				cmd, ret);
>  			return ret;
>  		}
> 
> 
> -- 
> Regards/Gruss,
>     Boris.
> 
> https://people.kernel.org/tglx/notes-about-netiquette
> 

