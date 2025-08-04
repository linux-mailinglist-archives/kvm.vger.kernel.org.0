Return-Path: <kvm+bounces-53931-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8A3B8B1A736
	for <lists+kvm@lfdr.de>; Mon,  4 Aug 2025 18:41:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9852E17F5FD
	for <lists+kvm@lfdr.de>; Mon,  4 Aug 2025 16:41:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BE4C82853F8;
	Mon,  4 Aug 2025 16:41:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QmxZrb91"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D58122356CF
	for <kvm@vger.kernel.org>; Mon,  4 Aug 2025 16:41:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754325700; cv=none; b=DZXjdiiqm4llperFKF/0deVpe7dMLki7Xgwxeh1XHoLMupAc/3QXc9UfaNZdS/Kv0czO7MHVBm3+tztiz3Va0UeaoEwZMsYYH9ESbzTQIGhMOleRcseJAvOVPW9C84NiSyf3fT0AmBzSBFzMms2SjAdXYiKQNtHmYD9LNLtp+iY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754325700; c=relaxed/simple;
	bh=9+H/ui/Y9H80qssq6UbLLHPuj8r299esy1nQzFXWemY=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=J9JeMSxJvVXPYxS5xfoey8clxc3Tak5zsSf2fI3BHaGuiCWKylqAh++yPcgbjefuXccdZZj0sSzBnctPBebYmgVDAHZdv66QyrUjwCXxbFFVY4b6UwfIs9/uiAj+qNY1I/5fU7gEXFE4MNaaK2GATDPl3GU7CQWzA3Ymr9HyHDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QmxZrb91; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B449C4CEE7;
	Mon,  4 Aug 2025 16:41:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754325700;
	bh=9+H/ui/Y9H80qssq6UbLLHPuj8r299esy1nQzFXWemY=;
	h=Date:From:To:Cc:Subject:In-Reply-To:From;
	b=QmxZrb91zhYID3uFBrV64cfu/nBfqT3po5295anvSKPBdhhX5I7XOgbAZQBezFyAA
	 LPGXMboZgJeNEgQBpefeDVUZCA2V1AjN8ELc3ryZVrYAEiuigz/AqNm4UxsjVoIPNO
	 hI3fnj6L0zNThnry3txm/foniJL6jkbmNutmvE6U/CYZ8WcXXuhvsV1AvZbD0dHu+T
	 nvdd6XcB8hC6sy43dqZm90mChqucIf9KkSLQwnSqpMfh2ppTA3yTOUfh6GVNXsNkt8
	 EyP9WEw9FBAeUly+vjlTgonDDYRXp4KZ6A7G19waXwP8BdZplpV2kS1Y8tfZtmSaN3
	 uexGBSf7T3UtQ==
Date: Mon, 4 Aug 2025 11:41:39 -0500
From: Bjorn Helgaas <helgaas@kernel.org>
To: Chaitanya Kulkarni <kch@nvidia.com>
Cc: kbusch@kernel.org, axboe@fb.com, hch@lst.de, sagi@grimberg.me,
	alex.williamson@redhat.com, cohuck@redhat.com, jgg@ziepe.ca,
	yishaih@nvidia.com, shameerali.kolothum.thodi@huawei.com,
	kevin.tian@intel.com, mjrosato@linux.ibm.com, mgurtovoy@nvidia.com,
	linux-nvme@lists.infradead.org, kvm@vger.kernel.org,
	Konrad.wilk@oracle.com, martin.petersen@oracle.com,
	jmeneghi@redhat.com, arnd@arndb.de, schnelle@linux.ibm.com,
	bhelgaas@google.com, joao.m.martins@oracle.com,
	Lei Rao <lei.rao@intel.com>
Subject: Re: [RFC PATCH 4/4] vfio-nvme: implement TP4159 live migration cmds
Message-ID: <20250804164139.GA3629027@bhelgaas>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250803024705.10256-5-kch@nvidia.com>

On Sat, Aug 02, 2025 at 07:47:05PM -0700, Chaitanya Kulkarni wrote:
> Implements TP4159-based live migration support in vfio-nvme
> driver by integrating command execution, controller state handling,
> and vfio migration state transitions.
> 
> Key features:
> 
> - Use nvme_submit_vf_cmd() and nvme_get_ctrl_id() helpers
>   in the NVMe core PCI driver for submitting admin commands on VFs.
> 
> - Implements Migration Send (opcode 0x43) and Receive (opcode 0x42)
>   command handling for suspend, resume, get/set controller state.
> 
>   _Remark_:-
>   We are currently in the process of defining the state in TP4193, 
>   so the current state management code will be replaced with TP4193.
>   However, in this patch we include TP4159-compatible state management
>   code for the sake of completeness.
> 
> - Adds parsing and serialization of controller state including:
>   - NVMeCS v0 controller state format (SCS-FIG6, FIG7, FIG8)
>   - Supported Controller State Formats (CNS=0x20 response)
>   - Migration file abstraction with read/write fileops
> 
> - Adds debug decoders to log IOSQ/IOCQ state during migration save
> 
> - Allocates anon inodes to handle save and resume file interfaces
>   exposed via VFIO migration file descriptors
> 
> - Adds vfio migration state machine transitions:
>   - RUNNING → STOP: sends suspend command
>   - STOP → STOP_COPY: extracts controller state (save)
>   - STOP_COPY → STOP: disables file and frees buffer
>   - STOP → RESUMING: allocates resume file buffer
>   - RESUMING → STOP: loads controller state via set state
>   - STOP → RUNNING: resumes controller via resume command
> 
> - Hooks vfio_migration_ops into vfio_pci_ops using:
>   - `migration_set_state()` and `migration_get_state()`
>   - Uses state_mutex + reset_lock for proper concurrency
> 
> - Queries Identify Controller (CNS=01h) to check for HMLMS bit
>   in OACS field, indicating controller migration capability
> 
> - Applies runtime checks for buffer alignment, format support,
>   and state size bounds to ensure spec compliance

Above mixes different verb forms: "Implements", "Adds", "Allocates",
etc. vs "Use".  I think there's some trend toward using the
imperative, e.g., "Implement", "Add", "Allocate", etc.

Similar for "sends", "extracts", "disables", ...

> +static int nvme_lm_get_ctrl_state_fmt(struct pci_dev *dev, bool debug,
> +				      struct nvme_lm_ctrl_state_fmts_info *fmt)
> +{
> +	__u8 i;
> +	int ret;
> +
> +	ret = nvme_lm_id_ctrl_state(dev, fmt);
> +	if (ret) {
> +		pr_err("Failed to get ctrl state formats (ret=%d)\n", ret);
> +		return ret;
> +	}
> +
> +	if (debug)
> +		pr_info("NV = %u, NUUID = %u\n", fmt->nv, fmt->nuuid);
> +
> +	if (debug) {
> +		for (i = 0; i < fmt->nv; i++) {
> +			pr_info("  Format[%d] Version = 0x%04x\n",
> +					i, le16_to_cpu(fmt->vers[i]));
> +		}
> +
> +		for (i = 0; i < fmt->nuuid; i++) {
> +			char uuid_str[37]; /* 36 chars + null */
> +
> +			snprintf(uuid_str, sizeof(uuid_str),
> +					"%02x%02x%02x%02x-%02x%02x-%02x%02x-"
> +					"%02x%02x-%02x%02x%02x%02x%02x%02x",
> +					fmt->uuids[i][0], fmt->uuids[i][1],
> +					fmt->uuids[i][2], fmt->uuids[i][3],
> +					fmt->uuids[i][4], fmt->uuids[i][5],
> +					fmt->uuids[i][6], fmt->uuids[i][7],
> +					fmt->uuids[i][8], fmt->uuids[i][9],
> +					fmt->uuids[i][10], fmt->uuids[i][11],
> +					fmt->uuids[i][12], fmt->uuids[i][13],
> +					fmt->uuids[i][14], fmt->uuids[i][15]);
> +
> +			pr_info("  UUID[%d] = %s\n", i, uuid_str);
> +		}
> +	}
> +
> +	return ret;

I think we know "ret == 0" here; if so, just use "return 0".

> +}
> +
> +static void nvmevf_init_get_ctrl_state_cmd(struct nvme_command *c, __u16 cntlid,
> +					   __u8 csvi, __u8 csuuidi,
> +					   __u8 csuidxp, size_t buf_len)
> +{
> +	c->lm.recv.opcode = nvme_admin_lm_recv;
> +	c->lm.recv.sel = NVME_LM_RECV_GET_CTRL_STATE;
> +	/*
> +	 * MOS fields treated as ctrl state version index, Use NVME V1 state.

s/, Use/; use/ ?

> +	 */
> +	/*
> +	 * For upstream read the supported controller state formats using
> +	 * identify command with cns value 0x20 and make sure NVME_LM_CSVI
> +	 * matches the on of the reported formats for NVMe states.

Above you capitalized "CNS".

"matches one of the"?  Not sure of your intent.

> +	 */
> +	c->lm.recv.mos = cpu_to_le16(csvi);
> +	/* Target Controller is this a right way to get the controller ID */

Is this a TODO item, i.e., a question that needs to be resolved?

> +	c->lm.recv.cntlid = cpu_to_le16(cntlid);
> +
> +	/*
> +	 * For upstream read the supported controller state formats using
> +	 * identify command with cns value 0x20 and make sure NVME_LM_CSVI
> +	 * matches the on of the reported formats for Vender specific states.

Above you capitalized "CNS".

"matches one of the"?  Not sure of your intent.

s/Vender/Vendor/

> +	 */
> +	/* adjust the state as per needed by setting the macro values */
> +	c->lm.recv.csuuidi = cpu_to_le32(csuuidi);
> +	c->lm.recv.csuidxp = cpu_to_le32(csuidxp);
> +
> +	/*
> +	 * Associates the Migration Receive command with the correct migration
> +	 * session UUID currently we set to 0. For now asssume that initiaor
> +	 * and target has agreed on the UUIDX 0 for all the live migration
> +	 * sessions.

s/Associates/Associate/
s/asssume/assume/
s/initiaor/initiator/
s/UUIDX/UUID/ ?

> +	 */
> +	c->lm.recv.uuid_index = cpu_to_le32(0);
> +
> +	/*
> +	 * Assume that data buffer is big enoough to hold the state,
> +	 * 0-based dword count.

s/enoough/enough/

> +	 */
> +	c->lm.recv.numd = cpu_to_le32(bytes_to_nvme_numd(buf_len));
> +}
> +
> +#define NVME_LM_MAX_NVMECS	1024
> +#define NVME_LM_MAX_VSD		1024
> +
> +static int nvmevf_get_ctrl_state(struct pci_dev *dev,
> +				__u8 csvi, __u8 csuuidi, __u8 csuidxp,
> +				struct nvmevf_migration_file *migf,
> +				struct nvme_lm_ctrl_state_info *state)
> +{
> +	struct nvme_command c = { };
> +	struct nvme_lm_ctrl_state *hdr;
> +	/* Make sure hdr_len is a multiple of 4 */
> +	size_t hdr_len = ALIGN(sizeof(*hdr), 4);
> +	__u16 id = nvme_get_ctrl_id(dev);
> +	void *local_buf;
> +	size_t len;
> +	int ret;
> +
> +	/* Step 1: Issue Migration Receive (Select = 0) to get header */
> +	local_buf = kzalloc(hdr_len, GFP_KERNEL);
> +	if (!local_buf)
> +		return -ENOMEM;
> +
> +	nvmevf_init_get_ctrl_state_cmd(&c, id, csvi, csuuidi, csuidxp, hdr_len);
> +	ret = nvme_submit_vf_cmd(dev, &c, NULL, local_buf, hdr_len);
> +	if (ret) {
> +		dev_warn(&dev->dev,
> +			"nvme_admin_lm_recv failed (ret=0x%x)\n", ret);
> +		kfree(local_buf);
> +		return ret;
> +	}
> +
> +	if (le16_to_cpu(hdr->nvmecss) > NVME_LM_MAX_NVMECS ||
> +	    le16_to_cpu(hdr->vss) > NVME_LM_MAX_VSD) {
> +		kfree(local_buf);
> +		return -EINVAL;
> +	}
> +
> +	hdr = local_buf;
> +	len = hdr_len + 4 * (le16_to_cpu(hdr->nvmecss) + le16_to_cpu(hdr->vss));
> +
> +	kfree(local_buf);
> +
> +	if (len == hdr_len)
> +		dev_warn(&dev->dev, "nvmecss == 0 or vss = 0\n");
> +
> +	/* Step 2: Allocate full buffer */
> +	migf->total_length = len;
> +	migf->vf_data = kvzalloc(migf->total_length, GFP_KERNEL);
> +	if (!migf->vf_data)
> +		return -ENOMEM;
> +
> +	memset(&c, 0, sizeof(c));
> +	nvmevf_init_get_ctrl_state_cmd(&c, id, csvi, csuuidi, csuidxp, len);
> +	ret = nvme_submit_vf_cmd(dev, &c, NULL, migf->vf_data, len);
> +	if (ret)
> +		goto free_big;
> +
> +	/* Populate state struct */
> +	hdr = (struct nvme_lm_ctrl_state *)migf->vf_data;
> +	state->raw = hdr;
> +	state->total_len = len;
> +	state->version = hdr->version;
> +	state->csattr = hdr->csattr;
> +	state->nvmecss = hdr->nvmecss;
> +	state->vss = hdr->vss;
> +	state->nvme_cs = hdr->data;
> +	state->vsd = hdr->data + le16_to_cpu(hdr->nvmecss) * 4;
> +
> +	return ret;

I think we know "ret == 0" here; if so, just use "return 0".

> +free_big:
> +	kvfree(migf->vf_data);
> +	return ret;
> +}

> +static void nvme_lm_debug_ctrl_state(struct nvme_lm_ctrl_state_info *state)
> +{
> +	const struct nvme_lm_nvme_cs_v0_state *cs;
> +	const struct nvme_lm_iosq_state *iosq;
> +	const struct nvme_lm_iocq_state *iocq;
> +	u16 niosq, niocq;
> +	int i;
> +
> +	pr_info("Controller State:\n");
> +	pr_info("Version    : 0x%04x\n", le16_to_cpu(state->version));
> +	pr_info("CSATTR     : 0x%02x\n", state->csattr);
> +	pr_info("NVMECS Len : %u bytes\n", le16_to_cpu(state->nvmecss) * 4);
> +	pr_info("VSD Len    : %u bytes\n", le16_to_cpu(state->vss) * 4);

I always wish messages like this were associated with a device, e.g.,
some flavor of dev_info().

> +
> +	cs = nvme_lm_parse_nvme_cs_v0_state(state->nvme_cs,
> +					    le16_to_cpu(state->nvmecss) * 4,
> +					    &niosq, &niocq);
> +	if (!cs) {
> +		pr_warn("Failed to parse NVMECS\n");
> +		return;
> +	}
> +
> +	iosq = cs->iosq;
> +	iocq = (const void *)(iosq + niosq);
> +
> +	for (i = 0; i < niosq; i++) {
> +		pr_info("IOSQ[%d]: SIZE=%u QID=%u CQID=%u ATTR=0x%x Head=%u "
> +			"Tail=%u\n", i,
> +			le16_to_cpu(iosq[i].qsize),
> +			le16_to_cpu(iosq[i].qid),
> +			le16_to_cpu(iosq[i].cqid),
> +			le16_to_cpu(iosq[i].attr),
> +			le16_to_cpu(iosq[i].head),
> +			le16_to_cpu(iosq[i].tail));
> +	}
> +
> +	for (i = 0; i < niocq; i++) {
> +		pr_info("IOCQ[%d]: SIZE=%u QID=%u ATTR=%u Head=%u Tail=%u\n", i,
> +			le16_to_cpu(iocq[i].qsize),
> +			le16_to_cpu(iocq[i].qid),
> +			le16_to_cpu(iocq[i].attr),
> +			le16_to_cpu(iocq[i].head),
> +			le16_to_cpu(iocq[i].tail));
> +	}
> +}

> +static int nvmevf_cmd_get_ctrl_state(struct nvmevf_pci_core_device *nvmevf_dev,
> +				     struct nvmevf_migration_file *migf)
> +{
> +	struct pci_dev *dev = nvmevf_dev->core_device.pdev;
> +	struct nvme_lm_ctrl_state_fmts_info fmt = { };
> +	struct nvme_lm_ctrl_state_info state = { };
> +	__u8 csvi = NVME_LM_CSVI;
> +	__u8 csuuidi = NVME_LM_CSUUIDI;
> +	__u8 csuidxp = 0;
> +	int ret;
> +
> +	/*
> +	 * Read the supported controller state formats to make sure they match
> +	 * csvi value specified in vfio-nvme without this check we'd not know
> +	 * which controller state format we are working with.

Run-on sentence.

> +	 */
> +	ret = nvme_lm_get_ctrl_state_fmt(dev, true, &fmt);
> +	if (ret)
> +		return ret;
> +	/*
> +	 * Number of versions NV cannot be less than controller state version
> +	 * index we are using, it's an error. Please note that CSVI is
> +	 * a configurable value user can define this macro at the compile time
> +	 * to select the required NVMe controller state version index from
> +	 * Supported Controller State Formats Data Structure.

Capitalize "CSVI" (or "csvi") consistently.  It's lower-case above and
upper-case here.  Also another run-on sentence.

> +	 */
> +	if (fmt.nv < csvi) {
> +		dev_warn(&dev->dev,
> +			 "required ctrl state format not found\n");
> +		ret = -EINVAL;
> +		goto out;
> +	}
> +
> +	ret = nvmevf_get_ctrl_state(dev, csvi, csuuidi, csuidxp, migf, &state);
> +	if (ret)
> +		goto out;
> +
> +	if (le16_to_cpu(state.version) != csvi) {
> +		dev_warn(&dev->dev,
> +			 "Unexpected controller state version: 0x%04x\n",
> +			 le16_to_cpu(state.version));
> +		ret = -EINVAL;
> +		goto out;
> +	}
> +
> +	/*
> +	 * Now that we have received the controller state decode the state
> +	 * properly for debugging purpose
> +	 */
> +
> +	nvme_lm_debug_ctrl_state(&state);
> +
> +	dev_info(&dev->dev, "Get controller state successful\n");
> +
> +out:
> +	kfree(fmt.ctrl_state_raw_buf);
> +	return ret;
> +}
> +
> +static int nvmevf_cmd_set_ctrl_state(struct nvmevf_pci_core_device *nvmevf_dev,
> +				     struct nvmevf_migration_file *migf)
> +{
> +	struct pci_dev *dev = nvmevf_dev->core_device.pdev;
> +	struct nvme_command c = { };
> +	u32 sel = NVME_LM_SEND_SEL_SET_CTRL_STATE;
> +	/* assume that data buffer is big enough to hold state in one cmd */
> +	u32 mos = NVME_LM_SEQIND_ONLY;
> +	u32 cntlid = nvme_get_ctrl_id(dev);
> +	u32 csvi = NVME_LM_CSVI;
> +	u32 csuuidi = NVME_LM_CSUUIDI;
> +	int ret;
> +
> +	c.lm.send.opcode = nvme_admin_lm_send;
> +	/* mos = SEQIND = 0b11 (Only) in MOS bits [17:16] */
> +	c.lm.send.cdw10 = cpu_to_le32((mos << 16) | sel);
> +	/*
> +	 * Assume that we are only working on NVMe state and not on vendor
> +	 * specific state.
> +	 */
> +	c.lm.send.cdw11 = cpu_to_le32(csuuidi << 24 | csvi << 16 | cntlid);
> +
> +	/*
> +	 * Associates the Migration Send command with the correct migration
> +	 * session UUID currently we set to 0. For now asssume that initiaor
> +	 * and target has agreed on the UUIDX 0 for all the live migration
> +	 * sessions.

s/Associates/Associate/
s/asssume/assume/
s/initiaor/initiator/
s/UUIDX/UUID/ ?

> +	 */
> +	c.lm.send.cdw14 = cpu_to_le32(0);
> +	/*
> +	 * Assume that data buffer is big enoough to hold the state,
> +	 * 0-based dword count.

s/enoough/enough/

> +	 */
> +	c.lm.send.cdw15 = cpu_to_le32(bytes_to_nvme_numd(migf->total_length));
> +
> +	ret = nvme_submit_vf_cmd(dev, &c, NULL, migf->vf_data,
> +				 migf->total_length);
> +	if (ret) {
> +		dev_warn(&dev->dev,
> +			 "Load the device states failed (ret=0x%x)\n", ret);
> +		return ret;
> +	}
> +
> +	dev_info(&dev->dev, "Set controller state successful\n");
> +	return 0;
> +}

> +static struct nvmevf_migration_file *
> +nvmevf_pci_resume_device_data(struct nvmevf_pci_core_device *nvmevf_dev)
> +{
> +	struct nvmevf_migration_file *migf;
> +	int ret;
> +
> +	migf = kzalloc(sizeof(*migf), GFP_KERNEL);
> +	if (!migf)
> +		return ERR_PTR(-ENOMEM);
> +
> +	migf->filp = anon_inode_getfile("nvmevf_mig", &nvmevf_resume_fops, migf,
> +					O_WRONLY);
> +	if (IS_ERR(migf->filp)) {
> +		int err = PTR_ERR(migf->filp);
> +
> +		kfree(migf);
> +		return ERR_PTR(err);
> +	}
> +	stream_open(migf->filp->f_inode, migf->filp);
> +	mutex_init(&migf->lock);
> +
> +	/* Allocate buffer to load the device states and max states is 256K */

Why repeat the "#define MAX_MIGRATION_SIZE (256 * 1024)" value in the
comment?

> +	migf->vf_data = kvzalloc(MAX_MIGRATION_SIZE, GFP_KERNEL);
> +	if (!migf->vf_data) {
> +		ret = -ENOMEM;
> +		goto out_free;
> +	}
> +
> +	return migf;
> +
> +out_free:
> +	fput(migf->filp);
> +	return ERR_PTR(ret);
> +}

> +static struct file *
> +nvmevf_pci_set_device_state(struct vfio_device *vdev,
> +			    enum vfio_device_mig_state new_state)
> +{
> +	struct nvmevf_pci_core_device *nvmevf_dev = container_of(vdev,
> +			struct nvmevf_pci_core_device, core_device.vdev);
> +	enum vfio_device_mig_state next_state;
> +	struct file *res = NULL;
> +	int ret;
> +
> +	mutex_lock(&nvmevf_dev->state_mutex);
> +	while (new_state != nvmevf_dev->mig_state) {
> +		ret = vfio_mig_get_next_state(vdev, nvmevf_dev->mig_state,
> +					      new_state, &next_state);
> +		if (ret) {
> +			res = ERR_PTR(-EINVAL);
> +			break;
> +		}
> +
> +		res = nvmevf_pci_step_device_state_locked(nvmevf_dev,
> +							  next_state);
> +		if (IS_ERR(res))
> +			break;
> +		nvmevf_dev->mig_state = next_state;
> +		if (WARN_ON(res && new_state != nvmevf_dev->mig_state)) {
> +			fput(res);
> +			res = ERR_PTR(-EINVAL);
> +			break;
> +		}
> +	}
> +	nvmevf_state_mutex_unlock(nvmevf_dev);
> +	return res;
> +}
> +
> +static int nvmevf_pci_get_device_state(struct vfio_device *vdev,
> +				       enum vfio_device_mig_state *curr_state)
> +{
> +	struct nvmevf_pci_core_device *nvmevf_dev = container_of(
> +			vdev, struct nvmevf_pci_core_device, core_device.vdev);
> +
> +	mutex_lock(&nvmevf_dev->state_mutex);
> +	*curr_state = nvmevf_dev->mig_state;
> +	nvmevf_state_mutex_unlock(nvmevf_dev);

I see that you added nvmevf_state_mutex_unlock() because you want to
deal with deferred reset things at the same time as the
mutex_unlock(), but it does make it harder to read when we have to
know and verify that

  mutex_lock(&nvmevf_dev->state_mutex)
  nvmevf_state_mutex_unlock(nvmevf_dev)

is actually a lock/unlock of the same mutex.  Maybe there's no better
way and this is the best we can do.

> +	return 0;
> +}

> +static int nvmevf_migration_init_dev(struct vfio_device *core_vdev)
> +{
> +	struct nvmevf_pci_core_device *nvmevf_dev;
> +	struct pci_dev *pdev;
> +	int vf_id;
> +	int ret = -1;
> +
> +	nvmevf_dev = container_of(core_vdev, struct nvmevf_pci_core_device,
> +				  core_device.vdev);
> +	pdev = to_pci_dev(core_vdev->dev);
> +
> +	if (!pdev->is_virtfn)
> +		return ret;

"ret" seems pointless here since it's always -1.  You could just
"return -1" directly, although it looks like this is supposed to be a
negative errno, e.g., -EINVAL or whatever.

> +
> +	/*
> +	 * Get the identify controller data structure to check the live
> +	 * migration support.
> +	 */
> +	if (!nvmevf_migration_supp(pdev))
> +		return ret;
> +
> +	nvmevf_dev->migrate_cap = 1;
> +
> +	vf_id = pci_iov_vf_id(pdev);
> +	if (vf_id < 0)
> +		return ret;
> +	nvmevf_dev->vf_id = vf_id + 1;
> +	core_vdev->migration_flags = VFIO_MIGRATION_STOP_COPY;
> +
> +	mutex_init(&nvmevf_dev->state_mutex);
> +	spin_lock_init(&nvmevf_dev->reset_lock);
> +	core_vdev->mig_ops = &nvmevf_pci_mig_ops;
> +
> +	return vfio_pci_core_init_dev(core_vdev);
> +}

> +++ b/drivers/vfio/pci/nvme/nvme.h
> @@ -33,4 +33,7 @@ struct nvmevf_pci_core_device {
>  	struct nvmevf_migration_file *saving_migf;
>  };
>  
> +extern int nvme_submit_vf_cmd(struct pci_dev *dev, struct nvme_command *cmd,
> +			size_t *result, void *buffer, unsigned int bufflen);
> +extern u16 nvme_get_ctrl_id(struct pci_dev *dev);

Typical style in drivers/vfio/ omits the "extern" on function
declarations.

>  #endif /* NVME_VFIO_PCI_H */
> -- 
> 2.40.0
> 

