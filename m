Return-Path: <kvm+bounces-34971-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id AECACA08309
	for <lists+kvm@lfdr.de>; Thu,  9 Jan 2025 23:57:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D7BD73A0F68
	for <lists+kvm@lfdr.de>; Thu,  9 Jan 2025 22:57:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D49FC205E20;
	Thu,  9 Jan 2025 22:57:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="qEqDgSF/"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2041.outbound.protection.outlook.com [40.107.100.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46D944A1A;
	Thu,  9 Jan 2025 22:57:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.100.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736463430; cv=fail; b=KEE9EjpRhygfd+wpB5O9BQyKygFtFOCgBB3VAOm26JTZpG3H8BzpoRkvOIHTXqD4Fz2XhrxFNstvrMq39zV0XwmpuGzAtwgXz8SyQRAKJKLGtuWQXr5WbsBZbwcFkwjKE5GcGxKhbyKwUpXsoTOgEAv7YfNyWLDZ6lJU1N7hCVs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736463430; c=relaxed/simple;
	bh=bqu/E36/CSdB5zr5hkhzMCmSvs2DTkf94e2UvnW5XwE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=mgk5Wjmx4hJLJ/kzgF5afv6xwdpK7auRw0UWVul9H4DqHibpaYKysdVB3ujitBrKTjJfhzk+LRD7RDrMOxr5iC8+2xL9Ss8XdODNvwf8qidbESBRO9eYx/ZdR6UOm8E3RE95qqlJu5osULiOT+EkS+aEAABOEY8hYfQ+d1ArhLg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=qEqDgSF/; arc=fail smtp.client-ip=40.107.100.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EF+s6L7sWiUNGNmGbMGhbVJgE3VzcGSiSsdzs6B0jk/YSYM7In/5px7iUewXtlnjy7iG7fIa5J4gtPftBB7HaAKi3gtBUhVT0+YyBeGf3EY1u5jRAuCy+T8Gl0c1QH0NMhxMGkH2JhjyL8pCPWWnPy+qOQ0xutNmbGQ+GHyKaLBzpusrZTZTl+7q3emo7BJd6kWXg/EcdQnqz/FmTts1rtRPR69dmdthvCe4Q5KlQ4L8dhDA+8VzmtEgMUw8z88vzgQDl+DWZrwootOvMi7UeeHj5ZJ4444X9RUgoBmQlneYYXPHaO+zZN4KGm/vAkJypO0QFtWGZUUmOrBZvZomAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kK+YmTG2OfUqb63fHWg7HAICedJXIqYkP+IBq524cLw=;
 b=EihrZ/fEJfnI/kQmAqnpLw/FDXoNWMBdtUqmxqScMCZ1z/BY8RhAPARDYddW3NFN7xXxMdeOBUsvPnsNYq+GyA414WQr3xHbUjSZQOq3xQyjaQtJ2dnUY0gVoZzxxUJ7iQQPW8QolD1A9qxd486kgfOTeh/lrz60OEcn3LzvvYX5n5JGa2ERDR8Jd9tNqv0Bvf0EmLI86P2Nbb8fm2Cf47XrVF9wv5D0W0Ujmp6xle13/6QLKeJhtpXMIgBoxayGSDxKVjL0VVJDO2SqutZoOc8xZajr89APlXAwd9Cn7CSao1Zkhct/OFE1JWCIELcAaUNqKWigd4zSUGCEGZomsg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kK+YmTG2OfUqb63fHWg7HAICedJXIqYkP+IBq524cLw=;
 b=qEqDgSF/v6nKbAEUwK/zdnY15rs31tDrtRvaX2EKTwCbhJQJ6ep/RjgSiHvPThrXTGycxvHxEym/aT/fXVsMr3hvZiqRmjWzo0DYsXt50dVKd7wTP0qpX+Cqr+HtTN1OdYKOVVLnB2hUpwuVSNLsRGwOHWtGgMMedyNW87rpw+VktkPtyqHamYJsmcXStc8BC68mTDT5ouplhkkwyUEGoQG/uQRAO0u7MdslVAy34eZjDzG3cRAorJr0dPaJCeStq6abOhXXvXGQMhgvQEDo5YZP7CLtvayPDyCZEYtrrhYGk64TEEZpZmmVWNQrNQmhSHYcXKFBv3v9wlGzSxvLaw==
Received: from SA1PR12MB7199.namprd12.prod.outlook.com (2603:10b6:806:2bc::21)
 by PH7PR12MB8796.namprd12.prod.outlook.com (2603:10b6:510:272::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8335.11; Thu, 9 Jan
 2025 22:57:06 +0000
Received: from SA1PR12MB7199.namprd12.prod.outlook.com
 ([fe80::ae1b:d89a:dfb6:37c2]) by SA1PR12MB7199.namprd12.prod.outlook.com
 ([fe80::ae1b:d89a:dfb6:37c2%4]) with mapi id 15.20.8335.010; Thu, 9 Jan 2025
 22:57:06 +0000
From: Ankit Agrawal <ankita@nvidia.com>
To: Alex Williamson <alex.williamson@redhat.com>
CC: Jason Gunthorpe <jgg@nvidia.com>, Yishai Hadas <yishaih@nvidia.com>,
	"shameerali.kolothum.thodi@huawei.com"
	<shameerali.kolothum.thodi@huawei.com>, "kevin.tian@intel.com"
	<kevin.tian@intel.com>, Zhi Wang <zhiw@nvidia.com>, Aniket Agashe
	<aniketa@nvidia.com>, Neo Jia <cjia@nvidia.com>, Kirti Wankhede
	<kwankhede@nvidia.com>, "Tarun Gupta (SW-GPU)" <targupta@nvidia.com>, Vikram
 Sethi <vsethi@nvidia.com>, Andy Currid <acurrid@nvidia.com>, Alistair Popple
	<apopple@nvidia.com>, John Hubbard <jhubbard@nvidia.com>, Dan Williams
	<danw@nvidia.com>, "Anuj Aggarwal (SW-GPU)" <anuaggarwal@nvidia.com>, Matt
 Ochs <mochs@nvidia.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 2/3] vfio/nvgrace-gpu: Expose the blackwell device PF
 BAR1 to the VM
Thread-Topic: [PATCH v2 2/3] vfio/nvgrace-gpu: Expose the blackwell device PF
 BAR1 to the VM
Thread-Index: AQHbX5hfP9htPVO4NEOTWqZoFjXWPbMO2CWAgAAZD8Y=
Date: Thu, 9 Jan 2025 22:57:06 +0000
Message-ID:
 <SA1PR12MB719977EDD0733752960615F4B0132@SA1PR12MB7199.namprd12.prod.outlook.com>
References: <20250105173615.28481-1-ankita@nvidia.com>
	<20250105173615.28481-3-ankita@nvidia.com>
 <20250109142123.3537519a.alex.williamson@redhat.com>
In-Reply-To: <20250109142123.3537519a.alex.williamson@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR12MB7199:EE_|PH7PR12MB8796:EE_
x-ms-office365-filtering-correlation-id: d674cd4e-718f-44d1-2d7e-08dd3100f0b2
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|366016|38070700018;
x-microsoft-antispam-message-info:
 =?iso-8859-1?Q?o7QvIRztnuqSe6ghBfLyq5jMGzZ1GzxdO7vNz0Y2TPaEwe+KCmLcF+TeNb?=
 =?iso-8859-1?Q?CHABXZZWGZCQnibCNdS+7Y9Grra/hBTSxxGlFKINhS31F3BAAf3eFK43wr?=
 =?iso-8859-1?Q?Bm5FSvU9/o1xJ+/xe+BexlWqRR0/2YOmwhUUkFQhqmr6dxldqWIe9U0RzJ?=
 =?iso-8859-1?Q?zPMyJxLc9mSXoy6gqD5woF0ruybIJo1LOYDXzXBdh9Sey4HuOpcj0wfkGA?=
 =?iso-8859-1?Q?oHlbuudiLNutjHkyob0qTS2YQzE7eEJGHJGW9tyahMIRC8hW2iLMhs98RH?=
 =?iso-8859-1?Q?bVb+Zdir7J2YaR/5EXkAG2yhoZkOfSRrt67xezHT8L4rWbvtnjHc8ukyBC?=
 =?iso-8859-1?Q?NlUPsbmaNrkm3wmw6V/XPIAkToRx3+wlJfDW+SWjVhbcFE0Qn/zQUurLIE?=
 =?iso-8859-1?Q?vwWG2BSIOKmEsTwARH6rjrpMF2RqKvrjSy1FQuCfvUSGCiwymW+6LYCVj7?=
 =?iso-8859-1?Q?G/tpIFimHZORF3GuQuJyBG0r2RDrVm4SgtPp7RhBkmKEbizFw0mmdaYeic?=
 =?iso-8859-1?Q?/JLbzF9c5esarS99FF2ITBOBfai1xNkPKslvMn3q7TBxRmGQCb85vHiQYy?=
 =?iso-8859-1?Q?V0CTjZmur66nHpZbO1oPjLsMftEhZb1rYcTIGBJR2/w1bx5nJ9TihxxJiK?=
 =?iso-8859-1?Q?y80f3B4JMnJIyk78nmAgSf4Wz7/HuMutd4vR8AquwUOg0gklmnH0AkVu6U?=
 =?iso-8859-1?Q?xXduUdMQe1qSICkuKrDVfQON45f7Mezfyfn4sHnT0xq8sU8ey6uGOSbYRH?=
 =?iso-8859-1?Q?p9y3AKoCtz3C/1naZXgWfA9CzOVkcBKhMLbiGplSZDBpPAsjua9mmM/HVb?=
 =?iso-8859-1?Q?Pmzs4RKmi6ho2iSTLS2plEuSxQ35tb2Nb4juwcGanhxFxIrCjtJ2TZAio6?=
 =?iso-8859-1?Q?8mnK1ZRW4/66RKy28V7VWcDCciiyeImL2HycYiWfmg0KolvV/Wf5g+whLp?=
 =?iso-8859-1?Q?iQcXJc1JP7ImzLP2qNhkC2m4H3rGjRFKZFIQJt7AnMcNdq+o6gZZwf8tQy?=
 =?iso-8859-1?Q?ZuIvKdNwMrhipUSIIz7xBTKASpuoXiZDwLubD4StZxZdtmHLIF66nsu/Hq?=
 =?iso-8859-1?Q?AvfF2ydKmJLvbEPXotCcgJXE0Se0cur9CbhKdHd5N07G+PGlDTnL7ftIyW?=
 =?iso-8859-1?Q?OPkCZJl4Zeah6oidQv6AlNISY+RkH1ylRZMXUkiqZuTOKx1M93Ff+ExR5r?=
 =?iso-8859-1?Q?KzhtPsbBb8OIjIiOiSpfGTd1fYktvMxt2skBX0eNnegsUlnVM+GqoiXlgG?=
 =?iso-8859-1?Q?wPhxIatRpgkxyIX/jkhnZzBUQRcNT1TJKj1gwawF6e4cKRWwS54cw9sDYC?=
 =?iso-8859-1?Q?s9IpgwO0JlCbw8XglZJ5DDAOQZwK0dn/zMQpcDmVeqjCqkfJJQkkuzTXER?=
 =?iso-8859-1?Q?jpTm1SAVm4MFXrZqMAdy1ze3yc36yjEnK5dOhDvDgk3MQJsTfGAneM3HDX?=
 =?iso-8859-1?Q?wWe3zmBU79qryJOTHJDLoTTvRBGL7aoWGNt/OMYVaAlsLhX10so9FN38xg?=
 =?iso-8859-1?Q?xJ/X7c/ImOeMbbLbEAPGqI?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR12MB7199.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?NhY9gC9MzQLjkz7vkhdzjbAEnfWk0afzBmdAiJ6cENwkbwEwh5aQQg6ib0?=
 =?iso-8859-1?Q?XW0aSEP/o36i/h0jf+WevYarQGqdEQFUE5XhKFDWJrp/AzRFPBkQQFeEEv?=
 =?iso-8859-1?Q?XPfp34JyYcbGxsSHIvazLG3AU7ceATsAk9NfSO8cNJzzoW5oG7vUm6AQQz?=
 =?iso-8859-1?Q?GTmDaLG3SeueFponNJq8Gktel4uKpUagaOnETloZi3I4/DJN+rBg8+DFMa?=
 =?iso-8859-1?Q?AJjEUvklbCTyoD3DCmKq+QtMjD9xCWSkwon2z6knMNAK6AVFZon+/XMyT9?=
 =?iso-8859-1?Q?0q48tNa79v2QBxkrLbnJ9SWuon3PPJhWLfh4N/U5jCslB3GgB5ddW7H/lN?=
 =?iso-8859-1?Q?dtExPpYYyGUwve8IkTs2VLGuxwtJtXNhCzpaOHLiEvV/qUYrLQBWpZC5MC?=
 =?iso-8859-1?Q?jfPo1XYzB+3is7RlFPkSorKiyiUh/MYjVag1/7StoiG284OZylnD28LgN6?=
 =?iso-8859-1?Q?cJ2dnlzhdMJUR1Q+5XrbiMXOZDfGmSafbByE3OGwevoU7E3v+w2ML1PaqM?=
 =?iso-8859-1?Q?JgAmWZJGebg9Qc20SZ+iufsIOQXWDqmy/BSA0D24xvHzUtUisi9hy/KvQW?=
 =?iso-8859-1?Q?3qtwN9Cup5HIZ3YGzCV/u/7qE7a/g8FdqDO5VyCnflWw5CRvoSdzx+ocGq?=
 =?iso-8859-1?Q?vNdbQysy2vlAnjVfk/2kZpi4h8apJJecdRMeiO4lXEUMcEfpSMIjYNFkfH?=
 =?iso-8859-1?Q?g2PuAjYerl4WYCd6HSH4rDnJyxpxWMPBtWBGGZPVKSogASfBhW/VCgdM4z?=
 =?iso-8859-1?Q?5sl3aZ4JqPtd3eVq5fRA0Qgc50/Hv/M0mqGS/TyQcEE7+EuwxTFD7hweo7?=
 =?iso-8859-1?Q?SAV85SX4NNeTh+oX9Ma1K2ae60UsiKw5UqrghOYoaWYXVo4VlpjkhzkL+8?=
 =?iso-8859-1?Q?dqk571TJ5LtnVbTwTbsBgMEFZCqa4UKrlfIT9bIYWsv1ksGCz0BFOerDOt?=
 =?iso-8859-1?Q?BX0YN7nWjvCE42RekylZFqCXhZBzYXj4GJKAAJa5agqkHZ/JgRKZYm8Ntx?=
 =?iso-8859-1?Q?gA2/8b5ZLFVn7UbpLT2UinPWbZ7wK1hRq/gWrZcHc/I7J0Kf2vZQWpxKj4?=
 =?iso-8859-1?Q?WVbdhKzm+/VAaZoZ216B1xmIg9sY9BASmVj4XZl3ov38IZX5eGianAcNK+?=
 =?iso-8859-1?Q?lYz86jNjLL069+1tG+jFBm9HNe2bHTzGr4keRF8TASClbKPVHGEessn3J4?=
 =?iso-8859-1?Q?uT0yMspbB97eV2LIEoksL5dkv2+GfWD5x38h7L3VO1zouyLnS5IKk75yd2?=
 =?iso-8859-1?Q?IMVKLWai1goKql/vObqreuY+cC9xyXPgSqjhmH5vcd4gH7f01c+rzsLoFE?=
 =?iso-8859-1?Q?0GiZqwB0r5ocplznb0bI+yRwibWaUtGG4n3HvsnbYf8LZ6BPg9dp1VzHUs?=
 =?iso-8859-1?Q?jxIf7W2ygKORFOoAzOL7WIPyUYGSMu9NsMkIYrQewIYbGF4KOfrXT+8OiF?=
 =?iso-8859-1?Q?69NCJsNaFVD+iFsr7gbdZsK/Z3pSWCC/oxfJsj6Y7RMpXincdfp9J9I80V?=
 =?iso-8859-1?Q?G6QPhjipm6AkiDHXHTrA7AbaWBoEeVx5HFDH3AiGdvgs4jeDsvlYQLhiB5?=
 =?iso-8859-1?Q?VBuFJgk9kN5ZlclhhyAoQyvjBPs6yJsnQeKj7/GGrwV7rKwi5MSeqX0SWy?=
 =?iso-8859-1?Q?jiKdWkEfG5epg=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR12MB7199.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d674cd4e-718f-44d1-2d7e-08dd3100f0b2
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Jan 2025 22:57:06.4325
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QHD3wHxIOwtaM0r8t0EbZ8eDJgVkZ10AzCXFKhXm5GhyPDG/32P+T++/anh0QfF710D3o61TbC6dvHyGHswCYQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB8796

> Doesn't this work out much more naturally if we just do something like:=
=0A=
> =0A=
> diff --git a/drivers/vfio/pci/nvgrace-gpu/main.c=0A=
> b/drivers/vfio/pci/nvgrace-gpu/main.c index 85eacafaffdf..43a9457442ff=0A=
> 100644 --- a/drivers/vfio/pci/nvgrace-gpu/main.c=0A=
> +++ b/drivers/vfio/pci/nvgrace-gpu/main.c=0A=
> @@ -17,9 +17,6 @@=0A=
> #define RESMEM_REGION_INDEX VFIO_PCI_BAR2_REGION_INDEX=0A=
> #define USEMEM_REGION_INDEX VFIO_PCI_BAR4_REGION_INDEX=0A=
> =0A=
> -/* Memory size expected as non cached and reserved by the VM driver */=
=0A=
> -#define RESMEM_SIZE SZ_1G=0A=
> -=0A=
> /* A hardwired and constant ABI value between the GPU FW and VFIO=0A=
> driver. */ #define MEMBLK_SIZE SZ_512M=0A=
> =0A=
> @@ -72,7 +69,7 @@ nvgrace_gpu_memregion(int index,=0A=
> =A0=A0=A0=A0=A0=A0=A0 if (index =3D=3D USEMEM_REGION_INDEX)=0A=
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 return &nvdev->usemem;=0A=
> =0A=
> -=A0=A0=A0=A0=A0=A0 if (index =3D=3D RESMEM_REGION_INDEX)=0A=
> +=A0=A0=A0=A0=A0=A0 if (nvdev->resmem.memlength && index =3D=3D RESMEM_RE=
GION_INDEX)=0A=
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 return &nvdev->resmem;=0A=
> =0A=
> =A0=A0=A0=A0=A0=A0=A0 return NULL;=0A=
> @@ -757,6 +754,13 @@ nvgrace_gpu_init_nvdev_struct(struct pci_dev *pdev,=
=0A=
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0 u64 memphys, u64 memlength)=0A=
> {=0A=
>  =A0=A0=A0=A0=A0=A0=A0 int ret =3D 0;=0A=
> +=A0=A0=A0=A0=A0=A0 u64 resmem_size =3D 0;=0A=
> +=0A=
> +=A0=A0=A0=A0=A0=A0 /*=0A=
> +=A0=A0=A0=A0=A0=A0=A0 * Comment about the GH bug that requires this and =
fix in GB=0A=
> +=A0=A0=A0=A0=A0=A0=A0 */=0A=
> +=A0=A0=A0=A0=A0=A0 if (!nvdev->has_mig_hw_bug_fix)=0A=
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 resmem_size =3D SZ_1G;=0A=
> =0A=
> =A0=A0=A0=A0=A0=A0=A0 /*=0A=
> =A0=A0=A0=A0=A0=A0=A0=A0 * The VM GPU device driver needs a non-cacheable=
 region to=0A=
> support @@ -780,7 +784,7 @@ nvgrace_gpu_init_nvdev_struct(struct=0A=
> pci_dev *pdev,=0A=
> =A0=A0=A0=A0=A0=A0=A0=A0 * memory (usemem) is added to the kernel for usa=
ge by the VM=0A=
> =A0=A0=A0=A0=A0=A0=A0=A0 * workloads. Make the usable memory size membloc=
k aligned.=0A=
> =A0=A0=A0=A0=A0=A0=A0=A0 */=0A=
> -=A0=A0=A0=A0=A0=A0 if (check_sub_overflow(memlength, RESMEM_SIZE,=0A=
> +=A0=A0=A0=A0=A0=A0 if (check_sub_overflow(memlength, resmem_size,=0A=
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0 &nvdev->usemem.memlength)) {=0A=
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 ret =3D -EOVERFLOW;=0A=
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 goto done;=0A=
> @@ -813,7 +817,9 @@ nvgrace_gpu_init_nvdev_struct(struct pci_dev *pdev,=
=0A=
> =A0=A0=A0=A0=A0=A0=A0=A0 * the BAR size for them.=0A=
> =A0=A0=A0=A0=A0=A0=A0=A0 */=0A=
> =A0=A0=A0=A0=A0=A0=A0 nvdev->usemem.bar_size =3D=0A=
> roundup_pow_of_two(nvdev->usemem.memlength);=0A=
> -=A0=A0=A0=A0=A0=A0 nvdev->resmem.bar_size =3D=0A=
> roundup_pow_of_two(nvdev->resmem.memlength);=0A=
> +=A0=A0=A0=A0=A0=A0 if (nvdev->resmem.memlength)=0A=
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 nvdev->resmem.bar_size =3D=0A=
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 round=
up_pow_of_two(nvdev->resmem.memlength);=0A=
> =A0done:=0A=
> =A0=A0=A0=A0=A0=A0=A0 return ret;=0A=
> =A0}=0A=
> =0A=
=0A=
Thanks Alex, you suggestion does looks simpler and better.=0A=
=0A=
I'll test that out and send out an updated version of the patch.=0A=

