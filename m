Return-Path: <kvm+bounces-11686-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 77456879AE8
	for <lists+kvm@lfdr.de>; Tue, 12 Mar 2024 19:02:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 331822844A7
	for <lists+kvm@lfdr.de>; Tue, 12 Mar 2024 18:02:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DFBFD1386D4;
	Tue, 12 Mar 2024 18:02:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UL1CPy9n"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22A167C084
	for <kvm@vger.kernel.org>; Tue, 12 Mar 2024 18:02:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710266526; cv=none; b=VNezcq/g/w9iZ8ZJsO6BLFhhDqBlTExcK/bIe7DJ3FlAQ0nQHlVmWyq38/mxDvsEyPn/M4RGgz9mneCwFnT6/XWCHZ+7FGXb+drOCd7Q4cuHPiami43hydHbHEYDEHWwKPr3CW0W61q46plzM9dt1YB63EAlZqi8hGdDKPxRweo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710266526; c=relaxed/simple;
	bh=cO3l58UBHZqKfGv89SnWy5HsTWKwX8kPCoof057qYGU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dDCyq4kruKJjNcymHwG8SCPdhXzNxXIZQ02Sdny9ho5tSp/DQGMRscO9w0Tb3pgOCkHtVRTYvetXm1GM7GDJ35nVs6KuDRouNdmgjdVrSXz09Es0t92RnQTTHgXYWfNoJjRP5yJkf9MHbtwi/S+p61NSNyEAkY0pAYeffXWdc7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=UL1CPy9n; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1710266524; x=1741802524;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=cO3l58UBHZqKfGv89SnWy5HsTWKwX8kPCoof057qYGU=;
  b=UL1CPy9nKh6JmvX4v/kZjwNBzAHY7wo+Yb5hEIHj3CQWhHnxIOQeCD3u
   jDIwKHNkQPgNkm6fwIlrLUXx440b6+dUpx8cfQo24dV4tCX43xj7dVU2v
   MJu481C5fH0HhM1NWHulrjvHfLTr/30oOjChY4zc7AibC195jQQjWWwzb
   0MQVv8igcAMfmdSHL04J9dCNLHaR4ppeeKzb2QQ4B2M5fLTRogUoh5d1x
   QM+F/DexmMzZs92/bQfC0LW3Ba2ia7/cJjOkvU5Wig3QGCcpuNq6cehlG
   7gNXcHE1+8VcXb77U4Xz/RlnXZWiAIhXZObPjDo16BjQphSu+xCKjxwtn
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,11011"; a="16394495"
X-IronPort-AV: E=Sophos;i="6.07,119,1708416000"; 
   d="scan'208";a="16394495"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2024 11:02:03 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,119,1708416000"; 
   d="scan'208";a="11521531"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2024 11:02:03 -0700
Date: Tue, 12 Mar 2024 11:02:01 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	David Hildenbrand <david@redhat.com>,
	Igor Mammedov <imammedo@redhat.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Yanan Wang <wangyanan55@huawei.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Ani Sinha <anisinha@redhat.com>, Peter Xu <peterx@redhat.com>,
	Cornelia Huck <cohuck@redhat.com>, Eric Blake <eblake@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org,
	qemu-devel@nongnu.org, Michael Roth <michael.roth@amd.com>,
	Claudio Fontana <cfontana@suse.de>,
	Gerd Hoffmann <kraxel@redhat.com>,
	Isaku Yamahata <isaku.yamahata@gmail.com>,
	Chenyi Qiang <chenyi.qiang@intel.com>, isaku.yamahata@intel.com,
	isaku.yamahata@linux.intel.com
Subject: Re: [PATCH v5 49/65] i386/tdx: handle TDG.VP.VMCALL<GetQuote>
Message-ID: <20240312180201.GI935089@ls.amr.corp.intel.com>
References: <20240229063726.610065-1-xiaoyao.li@intel.com>
 <20240229063726.610065-50-xiaoyao.li@intel.com>
 <Ze7Ojzty99AbShE3@redhat.com>
 <0f5e1559-bd65-4f3b-bd7a-b166f53dce38@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <0f5e1559-bd65-4f3b-bd7a-b166f53dce38@intel.com>

On Tue, Mar 12, 2024 at 03:44:32PM +0800,
Xiaoyao Li <xiaoyao.li@intel.com> wrote:

> On 3/11/2024 5:27 PM, Daniel P. Berrangé wrote:
> > On Thu, Feb 29, 2024 at 01:37:10AM -0500, Xiaoyao Li wrote:
> > > From: Isaku Yamahata <isaku.yamahata@intel.com>
> > > 
> > > Add property "quote-generation-socket" to tdx-guest, which is a property
> > > of type SocketAddress to specify Quote Generation Service(QGS).
> > > 
> > > On request of GetQuote, it connects to the QGS socket, read request
> > > data from shared guest memory, send the request data to the QGS,
> > > and store the response into shared guest memory, at last notify
> > > TD guest by interrupt.
> > > 
> > > command line example:
> > >    qemu-system-x86_64 \
> > >      -object '{"qom-type":"tdx-guest","id":"tdx0","quote-generation-socket":{"type": "vsock", "cid":"1","port":"1234"}}' \
> > 
> > Can you illustrate this with 'unix' sockets, not 'vsock'.
> 
> Are you suggesting only updating the commit message to an example of unix
> socket? Or you want the code to test with some unix socket QGS?
> 
> (It seems the QGS I got for testing, only supports vsock socket. Because at
> the time when it got developed, it was supposed to communicate with drivers
> inside TD guest directly not via VMM (KVM+QEMU). Anyway, I will talk to
> internal folks to see if any plan to support unix socket.)

You can use small utility to proxy sockets for testing purpose. The famous one
is socat or nmap ncat. They support vsock. At least their latest version does.

QGS <-vsock-> socat <-unix domain-> qemu
-- 
Isaku Yamahata <isaku.yamahata@intel.com>

