Return-Path: <kvm+bounces-59708-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 385D4BC8DC7
	for <lists+kvm@lfdr.de>; Thu, 09 Oct 2025 13:41:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 20B984F9294
	for <lists+kvm@lfdr.de>; Thu,  9 Oct 2025 11:41:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E15AD2DFA3A;
	Thu,  9 Oct 2025 11:41:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Vugm91pf"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4641E1A2545
	for <kvm@vger.kernel.org>; Thu,  9 Oct 2025 11:41:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760010073; cv=none; b=L3T/T7cUZBtfTyihFIQaWzfXKHdjWNBFe8DaN8Wj+iHAxrG2rHviq4EMg3JiDrGfd6rtYXzYdui0+F7kJZTQQ0ilrWDcdmWGa8DRaEbw+58Qgn7/nZSodBe1iIDp+W3cfj1800F38BGybIRrmH80sN8CiVmAGti54kNKuIHbUY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760010073; c=relaxed/simple;
	bh=2Uv7azk8/ScrcYsjOWBZkDGwc3I98PVTjPq3g5zlPTQ=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=pXMrK5kPbop+aCk7Du4y1eABqwk/FPJgkQ6+rRRaW7yg5UK1mVsqMuE0fxO7DTe5pyHOiAlNWiTWEGN7I9N8mi7YiaC9YLpeAPJ1MFly8sHEO7rJ8OMFpDIfmUNXyppMozc1rTCJxcaub17rk5hjUsUCxTxPC6QP7Potwg0oivQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Vugm91pf; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760010067;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=6LBwgHAck6qzLtHSd098K7JOIjp1DnHZWDlC6UXD1V4=;
	b=Vugm91pfVvxCPD0mE/uvPGxs7DC8uRABSZfStxqjWIT79/iJTpZwtK880kW8xBc0XnmbwV
	9+vQ+/sIX5d8xlK4PJUMKk1y3waSKycZEziv4dtQl3r4+duNqJr7XN0P2uFx4aR09QumfO
	utoBoHRR5D4keGgsjaTrEqLqcoMShZY=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-483-KnlBGFbJO9G_68MLWcG5yg-1; Thu,
 09 Oct 2025 07:41:06 -0400
X-MC-Unique: KnlBGFbJO9G_68MLWcG5yg-1
X-Mimecast-MFC-AGG-ID: KnlBGFbJO9G_68MLWcG5yg_1760010064
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id DCE94197752F;
	Thu,  9 Oct 2025 11:40:43 +0000 (UTC)
Received: from blackfin.pond.sub.org (unknown [10.45.242.6])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 645E51944A8A;
	Thu,  9 Oct 2025 11:40:39 +0000 (UTC)
Received: by blackfin.pond.sub.org (Postfix, from userid 1000)
	id 4746B21E6A27; Thu, 09 Oct 2025 13:40:36 +0200 (CEST)
From: Markus Armbruster <armbru@redhat.com>
To: Zhao Liu <zhao1.liu@linux.intel.com>
Cc: Eduardo Habkost <eduardo@habkost.net>,  Marcel Apfelbaum
 <marcel.apfelbaum@gmail.com>,  Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?=
 <philmd@linaro.org>,
  Yanan Wang <wangyanan55@huawei.com>,  "Michael S . Tsirkin"
 <mst@redhat.com>,  Richard Henderson <richard.henderson@linaro.org>,
  Paolo Bonzini <pbonzini@redhat.com>,  Eric Blake <eblake@redhat.com>,
  Marcelo Tosatti <mtosatti@redhat.com>,  Daniel P . =?utf-8?Q?Berrang?=
 =?utf-8?Q?=C3=A9?=
 <berrange@redhat.com>,  Xiaoyao Li <xiaoyao.li@intel.com>,
  qemu-devel@nongnu.org,  kvm@vger.kernel.org,  Zhenyu Wang
 <zhenyu.z.wang@intel.com>,  Zhuocheng Ding <zhuocheng.ding@intel.com>,
  Babu Moger <babu.moger@amd.com>,  Yongwei Ma <yongwei.ma@intel.com>,
  Zhao Liu <zhao1.liu@intel.com>
Subject: Re: [PATCH v9 02/21] hw/core/machine: Support modules in -smp
In-Reply-To: <87plwgzzc4.fsf@pond.sub.org> (Markus Armbruster's message of
	"Wed, 28 Feb 2024 10:56:43 +0100")
References: <20240227103231.1556302-1-zhao1.liu@linux.intel.com>
	<20240227103231.1556302-3-zhao1.liu@linux.intel.com>
	<87plwgzzc4.fsf@pond.sub.org>
Date: Thu, 09 Oct 2025 13:40:36 +0200
Message-ID: <87jz14qp57.fsf@pond.sub.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

Markus Armbruster <armbru@redhat.com> writes:

> Zhao Liu <zhao1.liu@linux.intel.com> writes:
>
>> From: Zhao Liu <zhao1.liu@intel.com>
>>
>> Add "modules" parameter parsing support in -smp.
>>
>> Suggested-by: Xiaoyao Li <xiaoyao.li@intel.com>
>> Tested-by: Yongwei Ma <yongwei.ma@intel.com>
>> Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
>
> QAPI schema
> Acked-by: Markus Armbruster <armbru@redhat.com>

I missed something.  The patch added @modules without updating "The
ordering from ...":

    ##
    # @SMPConfiguration:
    #
    # Schema for CPU topology configuration.  A missing value lets QEMU
    # figure out a suitable value based on the ones that are provided.
    #
    # The members other than @cpus and @maxcpus define a topology of
    # containers.
    #
--> # The ordering from highest/coarsest to lowest/finest is: @drawers,
--> # @books, @sockets, @dies, @clusters, @cores, @threads.

Where does it go in this list?

The order below suggests between @clusters and @modules.

    #
    # Different architectures support different subsets of topology
    # containers.
    #
    # For example, s390x does not have clusters and dies, and the socket
    # is the parent container of cores.
    #
    # @cpus: number of virtual CPUs in the virtual machine
    #
    # @maxcpus: maximum number of hotpluggable virtual CPUs in the virtual
    #     machine
    #
    # @drawers: number of drawers in the CPU topology (since 8.2)
    #
    # @books: number of books in the CPU topology (since 8.2)
    #
    # @sockets: number of sockets per parent container
    #
    # @dies: number of dies per parent container
    #
    # @clusters: number of clusters per parent container (since 7.0)
    #
    # @modules: number of modules per parent container (since 9.1)
    #
    # @cores: number of cores per parent container
    #
    # @threads: number of threads per core
    #
    # Since: 6.1
    ##


