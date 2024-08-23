Return-Path: <kvm+bounces-24954-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6FA1E95D929
	for <lists+kvm@lfdr.de>; Sat, 24 Aug 2024 00:17:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2ED642842C5
	for <lists+kvm@lfdr.de>; Fri, 23 Aug 2024 22:17:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E6F11C8713;
	Fri, 23 Aug 2024 22:17:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KlqI+Glc"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C728192590;
	Fri, 23 Aug 2024 22:17:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724451452; cv=none; b=Uk/XgGAX+7W50CriN3YHomZNcGogFE5/z0jjI+lJCJPIefjdkWS+puVsKdHiP4tqgJWN7gMPCep6rzqxuA7hrGb+z+JSugh8Vwl/uVCrIK0Nv1jaNDWKXMTBzXEHhJx6od7uZIY1EwfblQdu7L8oBSQBrbdB5/iTPq+BGcZbR64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724451452; c=relaxed/simple;
	bh=WrEHdYXMheRANM0DatLMvX4pMsTiurjv8WMBfTIYxso=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=HZPIXt7RuqB0dmIE9srvJWGIxaQzQFTsnZJNLvjWU9LJKJ+SlFrbjgR/rWAEg9JqtUnP6kBdKaFoPLpL9GmS6odQycrmv+t6gYISIgHCZl2iVKQ8Usk05UVwK2IK05bzevF5hyPpv/KIJs8+g1r80Kzw3rrLBlh1faySQDh7Vv8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KlqI+Glc; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0807C32786;
	Fri, 23 Aug 2024 22:17:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724451452;
	bh=WrEHdYXMheRANM0DatLMvX4pMsTiurjv8WMBfTIYxso=;
	h=Date:From:To:Cc:Subject:In-Reply-To:From;
	b=KlqI+Glc+XQz0zORkjdVFVUhmb2H/2xhQ6lBbW3waQyNaPjZJDENcdZHJdW62/p9t
	 vgwygPQNYYaXsSRpOVUEdsK7UWzCiVQlamN5jMvxfTq0Rw5qNdHCnTS/gW9CCXJMvm
	 0HD9qYyl1Gik2li7mMQKDAv3uSHu0njirsMqyKKhWiSL7gOYGx9vAIV44l7Abdvfj5
	 J10EhJXt0Sw13K+IMFDoB81e/F7RkwTdFIg+qkALK3TjhQCxqGuxjJQjZPGHwojJeP
	 ok9zCfywGtGqB+f19BX0sYaW4MCc5SVfYWsuaR08CdKrhJh014Go4cqeay2coeEEqt
	 LGyBBEdg14aaQ==
Date: Fri, 23 Aug 2024 17:17:30 -0500
From: Bjorn Helgaas <helgaas@kernel.org>
To: Alexey Kardashevskiy <aik@amd.com>
Cc: kvm@vger.kernel.org, iommu@lists.linux.dev, linux-coco@lists.linux.dev,
	linux-pci@vger.kernel.org,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Dan Williams <dan.j.williams@intel.com>,
	pratikrajesh.sampat@amd.com, michael.day@amd.com,
	david.kaplan@amd.com, dhaval.giani@amd.com,
	Santosh Shukla <santosh.shukla@amd.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Michael Roth <michael.roth@amd.com>, Alexander Graf <agraf@suse.de>,
	Nikunj A Dadhania <nikunj@amd.com>,
	Vasant Hegde <vasant.hegde@amd.com>, Lukas Wunner <lukas@wunner.de>
Subject: Re: [RFC PATCH 01/21] tsm-report: Rename module to reflect what it
 does
Message-ID: <20240823221730.GA391170@bhelgaas>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240823132137.336874-2-aik@amd.com>

On Fri, Aug 23, 2024 at 11:21:15PM +1000, Alexey Kardashevskiy wrote:

Include the text from the title here so the commit log is
self-contained.

> And release the name for TSM to be used for TDISP-associated code.

