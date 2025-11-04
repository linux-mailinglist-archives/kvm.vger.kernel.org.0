Return-Path: <kvm+bounces-61937-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C81C4C2F084
	for <lists+kvm@lfdr.de>; Tue, 04 Nov 2025 03:54:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 64AB43BF45A
	for <lists+kvm@lfdr.de>; Tue,  4 Nov 2025 02:52:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 57D6E260592;
	Tue,  4 Nov 2025 02:52:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="q7xTFejP"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F65525A631;
	Tue,  4 Nov 2025 02:52:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762224748; cv=none; b=Kf70K87BbCgArm+k5AYj9T+kB6cnaqOcxUX8Mz1VvDfxgh3bpsi8LCyW7ybfxuJZelaO85JL6S7HNHN5LBdYTRp1EAD0PVgNdwhzjXEWSEDZ/OT/HvdbWVneh9wELsxreK4wqYDisfVFYCxcXMZE9rz8q9iydyp1ySkRr6lu0ps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762224748; c=relaxed/simple;
	bh=Xovpelytaf1rVw6/MGWZziRvb+wid13hMajWjKa65Y8=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=VhwOtx5rm+ql1bYHfJ+8Ri1n5QOBJmgwUOi8zO6w4bgJXqVqw13Ed4Ywjeu4XbuQSX0u6YNgc34h3at3pUJIeajusMYHwedZt6d+eaO1WpIV1BUJxrpWgqPMX1C0OJDsM3cRHcIClwwEc99wPCCuN08Eb8oW4DvodtW94VhCs68=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=q7xTFejP; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCA1DC4CEFD;
	Tue,  4 Nov 2025 02:52:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1762224748;
	bh=Xovpelytaf1rVw6/MGWZziRvb+wid13hMajWjKa65Y8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=q7xTFejPKd6NhT06RWpXtSixWQbEpsjjKBezm1wVg44aGl0ALe0Oy1XhGDJVqSHHy
	 MAJJ0qgiFXuHTQuaQRCrTT7oBrEjP3r5aNq6iZqPuLddO7lzY8BxtsRizHiiSc4pKe
	 hIbRUTmPyMmu1L6vvb9GyRzw3s52raw3T8RmJaig=
Date: Mon, 3 Nov 2025 18:52:26 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Michal Hocko <mhocko@suse.com>
Cc: Ankit Agrawal <ankita@nvidia.com>, Aniket Agashe <aniketa@nvidia.com>,
 Vikram Sethi <vsethi@nvidia.com>, Jason Gunthorpe <jgg@nvidia.com>, Matt
 Ochs <mochs@nvidia.com>, Shameer Kolothum <skolothumtho@nvidia.com>,
 "linmiaohe@huawei.com" <linmiaohe@huawei.com>, "nao.horiguchi@gmail.com"
 <nao.horiguchi@gmail.com>, "david@redhat.com" <david@redhat.com>,
 "lorenzo.stoakes@oracle.com" <lorenzo.stoakes@oracle.com>,
 "Liam.Howlett@oracle.com" <Liam.Howlett@oracle.com>, "vbabka@suse.cz"
 <vbabka@suse.cz>, "rppt@kernel.org" <rppt@kernel.org>, "surenb@google.com"
 <surenb@google.com>, "tony.luck@intel.com" <tony.luck@intel.com>,
 "bp@alien8.de" <bp@alien8.de>, "rafael@kernel.org" <rafael@kernel.org>,
 "guohanjun@huawei.com" <guohanjun@huawei.com>, "mchehab@kernel.org"
 <mchehab@kernel.org>, "lenb@kernel.org" <lenb@kernel.org>,
 "kevin.tian@intel.com" <kevin.tian@intel.com>, "alex@shazbot.org"
 <alex@shazbot.org>, Neo Jia <cjia@nvidia.com>, Kirti Wankhede
 <kwankhede@nvidia.com>, "Tarun Gupta (SW-GPU)" <targupta@nvidia.com>, Zhi
 Wang <zhiw@nvidia.com>, Dheeraj Nigam <dnigam@nvidia.com>, Krishnakant Jaju
 <kjaju@nvidia.com>, "linux-kernel@vger.kernel.org"
 <linux-kernel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
 "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
 "Jonathan.Cameron@huawei.com" <Jonathan.Cameron@huawei.com>,
 "ira.weiny@intel.com" <ira.weiny@intel.com>,
 "Smita.KoralahalliChannabasappa@amd.com"
 <Smita.KoralahalliChannabasappa@amd.com>, "u.kleine-koenig@baylibre.com"
 <u.kleine-koenig@baylibre.com>, "peterz@infradead.org"
 <peterz@infradead.org>, "linux-acpi@vger.kernel.org"
 <linux-acpi@vger.kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH v4 2/3] mm: handle poisoning of pfn without struct pages
Message-Id: <20251103185226.fea151c58ce7077b11b106aa@linux-foundation.org>
In-Reply-To: <aQjy0ZsVq7vhxtr7@tiehlicka>
References: <20251026141919.2261-1-ankita@nvidia.com>
	<20251026141919.2261-3-ankita@nvidia.com>
	<20251027172620.d764b8e0eab34abd427d7945@linux-foundation.org>
	<MW4PR12MB7213976611F767842380FB56B0FAA@MW4PR12MB7213.namprd12.prod.outlook.com>
	<aQRy4rafpvo-W-j6@tiehlicka>
	<SA1PR12MB71998D21DD1852EB074A11ABB0C6A@SA1PR12MB7199.namprd12.prod.outlook.com>
	<aQjy0ZsVq7vhxtr7@tiehlicka>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 3 Nov 2025 19:22:09 +0100 Michal Hocko <mhocko@suse.com> wrote:

> > Hi Michal, I am trying to replicate what is being done today for non-PFNMAP
> > memory failure in __add_to_kill
> > (https://github.com/torvalds/linux/blob/master/mm/memory-failure.c#L376).
> > For this series, I am inclined to keep it uniform.
> 
> Unless there is a very good reason for this code then I would rather not
> rely on an atomic allocation. This just makes the behavior hard to
> predict

I don't think this was addressed in the v5 series.

Yes please, anything we can do to avoid GFP_ATOMIC makes the kernel
more reliable.

