Return-Path: <kvm+bounces-68639-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id mGfhN6Plb2lhUQAAu9opvQ
	(envelope-from <kvm+bounces-68639-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 20 Jan 2026 21:29:23 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 48C2D4B4D6
	for <lists+kvm@lfdr.de>; Tue, 20 Jan 2026 21:29:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 3693092A396
	for <lists+kvm@lfdr.de>; Tue, 20 Jan 2026 18:08:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 09DDB44B694;
	Tue, 20 Jan 2026 18:08:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eaen7DRr"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D39B345753;
	Tue, 20 Jan 2026 18:08:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768932516; cv=none; b=LeRV7lBE7FB8effkozs2peFU6gNMB/mA2gHmZWBG4VUg91wwPRlcfbqM94ac9PsE0p5m9N//BBlExA+HuD0nil+p++rRHhJcotzHAvN0lxMwFuwGorIVJwtKEbNzzt+fWgp2sCRf8pyRnHqnZ8JKOMuG2m7Mr2FwF41zVGjTxq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768932516; c=relaxed/simple;
	bh=iPeLQUClZ+MDpbXM0eSkRUGIDQYyAShv0zDvLJ34TzA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pqQtESSASS1t1bP7NjT2/RUU9VSOrL33GlEYrWg/+qYYusExLQtsAl8WNl2MdpXxlQ9FrcuaYRjVZ1vrF7RkqGmOFex35UCm8xeq/90J0uw6nRI0Qs6Z56z4nKZa83hEXGyXWiSMPKkz4a57i2REAyeU4CTKilStdp1lyt/GqXk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eaen7DRr; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16257C19421;
	Tue, 20 Jan 2026 18:08:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768932515;
	bh=iPeLQUClZ+MDpbXM0eSkRUGIDQYyAShv0zDvLJ34TzA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=eaen7DRrJQ4BuE/5XfK+2pvuk1wxn8S7+PK/HopD8haSQ4wc6ROsSepDIcG0Ya/xl
	 WsiJN/in+saOwaV4vxNfkXDKX8vDNC7iJBXc5QpF91qbomrRhw4izBELY7HQtYGPmO
	 LbqLeZ4YRedpUqptV7WGi451y+rRBxFKXY/oZ5KfTCzTNGviHusZI2N7Y3+3MjDnXm
	 j19tGlM0nag5TpJsriaMYCclT6NwFryGO4GGrvzl2zKMJYSiDJ7ZvO7EUCnxCWjV8D
	 02q3IogQYGB2V5S/bKCI/BZgdKp8nztOpzXUayrFfB1x9Pjot3omS5D52bLND+9h5c
	 P3z5e387X7dzg==
Date: Tue, 20 Jan 2026 11:08:33 -0700
From: Keith Busch <kbusch@kernel.org>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>, linux-pci@vger.kernel.org,
	Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>,
	Alex Williamson <alex.williamson@redhat.com>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Donald Dutile <ddutile@redhat.com>, galshalom@nvidia.com,
	Joerg Roedel <jroedel@suse.de>, Kevin Tian <kevin.tian@intel.com>,
	kvm@vger.kernel.org, maorg@nvidia.com, patches@lists.linux.dev,
	tdave@nvidia.com, Tony Zhu <tony.zhu@intel.com>
Subject: Re: [PATCH v3 10/11] PCI: Check ACS DSP/USP redirect bits in
 pci_enable_pasid()
Message-ID: <aW_EoTarUr6LEZgy@kbusch-mbp>
References: <0-v3-8827cc7fc4e0+23f-pcie_switch_groups_jgg@nvidia.com>
 <10-v3-8827cc7fc4e0+23f-pcie_switch_groups_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <10-v3-8827cc7fc4e0+23f-pcie_switch_groups_jgg@nvidia.com>
X-Spamd-Result: default: False [-1.46 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW_WITH_FAILURES(-0.50)[];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-68639-lists,kvm=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	DMARC_POLICY_ALLOW(0.00)[kernel.org,quarantine];
	RCPT_COUNT_TWELVE(0.00)[18];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[kernel.org:+];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	R_SPF_SOFTFAIL(0.00)[~all:c];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[kbusch@kernel.org,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	ASN(0.00)[asn:7979, ipnet:2605:f480::/32, country:US];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[dfw.mirrors.kernel.org:rdns,dfw.mirrors.kernel.org:helo]
X-Rspamd-Queue-Id: 48C2D4B4D6
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Fri, Sep 05, 2025 at 03:06:25PM -0300, Jason Gunthorpe wrote:
> +static u16 pci_acs_ctrl_mask(struct pci_dev *pdev, u16 hw_cap)
> +{
> +	/*
> +	 * Egress Control enables use of the Egress Control Vector which is not
> +	 * present without the cap.
> +	 */
> +	u16 mask = PCI_ACS_EC;
> +
> +	mask = hw_cap & (PCI_ACS_SV | PCI_ACS_TB | PCI_ACS_RR |
> +				      PCI_ACS_CR | PCI_ACS_UF | PCI_ACS_DT);

I think you intended "mask |=", otherwise the initialization to
PCI_ACS_EC doesn't make sense.

