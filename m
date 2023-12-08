Return-Path: <kvm+bounces-3975-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id ABA5380AFAA
	for <lists+kvm@lfdr.de>; Fri,  8 Dec 2023 23:29:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 409341F21385
	for <lists+kvm@lfdr.de>; Fri,  8 Dec 2023 22:29:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 16DE25A0E6;
	Fri,  8 Dec 2023 22:29:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="pgizEkNm"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2063.outbound.protection.outlook.com [40.107.94.63])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A3701712;
	Fri,  8 Dec 2023 14:28:55 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G16COIAuPau43BgQLOWqxiGCk73qXP64kfBC5LG1uUqpDzhhJsaQFqS6POMPixUw8VY72c+QnZTWrX/JuOsi9hEZsXgfneuXQ1RAzTAkufncXxCE9bBtOwIzbkQPos6ymdBUAy+nBgC1Zv4wPd/v+T6f81b8WFyg/Jm3jSGSI8RP7YTIkk/NaPiAS68iJMbADIqm2ZVOY94gu+cATEXAMPq90two9KEQHVkYcd5inYT/6l8RZnjVUUK/oh3ia9tvmtHI+HZJEF5W68SU7LtuXCmXK1bVEJvMqFDh1R3Xe5TGC+ooawasUMVDgKpGAzYkV7YOkW6NazY02O53StQ9RA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rxNbUMoujh9v4RFtZuIlMwhqEyFVvbqEOsTWFeEC6TY=;
 b=J2Zgzt4wNP6etbqEDd3izruYyhdZ5ysUGFHuAfH2o3JOr9Wgt85GA0b7E2Da6Q1RgdEUEs5cp+caKp249pt0U8ebdWL0AEJiLA3nUp8phNPlQ5pU+fU+LtW3RXPoBkfz3IwfV0YgrLg21WLzH1IU3bSN1dNGINUNt2DRZbW4fyciRjh8YPgKYsTrNtJ6+eK0CQDzQ2V87pUplZ+gZed4Dqyng2pskxEoEvHHj1BbXJwSm1vPjWriKNMCkIK+/o/YFU2IZyjORvATRLj8Sowc6Us2ksSmCYnYTVleh4lzZ27QJr7hpzwYAoyNbZC0e7XPOOWI4TWb3Gr9JvWkkw5L8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rxNbUMoujh9v4RFtZuIlMwhqEyFVvbqEOsTWFeEC6TY=;
 b=pgizEkNmJoV0lxd3Y6eUXYxcZ6pG7J0DleaiL7Xr8mJXic/h7YRt6PQDpIBNaSEJPSDpciCcLQ+Tiye4mAe7Q6j739TXOkkXvF+EuY3WbuXAWSUpx8xBXtsAilCTozLBYIRYTLyH0QAYZVFhGWeE1HzMlQI/u50nA8lsGMyzYJc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH0PR12MB7982.namprd12.prod.outlook.com (2603:10b6:510:28d::5)
 by IA0PR12MB8647.namprd12.prod.outlook.com (2603:10b6:208:480::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7068.28; Fri, 8 Dec
 2023 22:28:49 +0000
Received: from PH0PR12MB7982.namprd12.prod.outlook.com
 ([fe80::bec4:77b3:e1d1:5615]) by PH0PR12MB7982.namprd12.prod.outlook.com
 ([fe80::bec4:77b3:e1d1:5615%5]) with mapi id 15.20.7068.028; Fri, 8 Dec 2023
 22:28:48 +0000
Message-ID: <d1a5437e-a1ac-1fde-dfdf-9c1d8768b052@amd.com>
Date: Fri, 8 Dec 2023 14:28:46 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH iwl-next v4 03/12] ice: Introduce VF state
 ICE_VF_STATE_REPLAYING_VC for migration
Content-Language: en-US
To: Yahui Cao <yahui.cao@intel.com>, intel-wired-lan@lists.osuosl.org
Cc: kvm@vger.kernel.org, netdev@vger.kernel.org, lingyu.liu@intel.com,
 kevin.tian@intel.com, madhu.chittim@intel.com, sridhar.samudrala@intel.com,
 alex.williamson@redhat.com, jgg@nvidia.com, yishaih@nvidia.com,
 shameerali.kolothum.thodi@huawei.com, brett.creeley@amd.com,
 davem@davemloft.net, edumazet@google.com, kuba@kernel.org, pabeni@redhat.com
References: <20231121025111.257597-1-yahui.cao@intel.com>
 <20231121025111.257597-4-yahui.cao@intel.com>
From: Brett Creeley <bcreeley@amd.com>
In-Reply-To: <20231121025111.257597-4-yahui.cao@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0375.namprd03.prod.outlook.com
 (2603:10b6:a03:3a1::20) To PH0PR12MB7982.namprd12.prod.outlook.com
 (2603:10b6:510:28d::5)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR12MB7982:EE_|IA0PR12MB8647:EE_
X-MS-Office365-Filtering-Correlation-Id: a577b004-e4c3-4b1b-3c08-08dbf83d0c31
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	I3dX42B+f9ZNMZtULZ1FoFvPs250ObdvK16gtKbsFX6LehnzRpYKq1gIwFYCCJTjPtUj6+VUTJOhmhOd9ouybGEfK2oAMe41BaTrclPR3dMOggSQsSveSs0QZkwRWMQCyfBu8XIrFIhxhk2cWZz8QgKgbgGHfC8Z1tn62+TEQxbMizrCLkyOI2iqJlueOHB2t9Vi15gtN5lEnvcBfQIxPd9z7HBYUzsq8nE4cYJiO2u7fMmhVwiOOGB4Ki1gd5xNcgjhq61QMy5P0WYX+8R/2obLseBxPkWGi9bQqkOBm14w/0iD4iTSNi6F63JqKRrNKc6QZrOVPbpyqdWhucqto9DzLEBttVDyACWi7B8s+qXy8dxQp7aqaAm9dR5Du4gGUqCj5jBkfrY4DzcXKe8bqhzfg4EwDezUfDc/yCPJfFQUj3OfGaxrfVsynnsco8tYuFGeoBlLA+VXqdELbJfHkvC2te4Zo4A7QOytkB4jFwqH94L07gGbDLL0p/z6a9C2okK5r/uKwpC9U7bJmSTyvWrQpl3WZcmQ8XXhZQbO9KTAZpivea2tQvpXbx6M20bGbAFEwXe8+HS0jatxfq263tB+oz7tpAse5KSVrnCq5YgenqbcMiujAKdNQuvJnx/OZSjYN9f4jmngvEzn5lWSAnc6pz6Zr7bdYdvyFPvzf4UiZuF2lLaASvfM6kp1rjvf
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB7982.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(39860400002)(136003)(376002)(346002)(396003)(230922051799003)(230173577357003)(230273577357003)(64100799003)(186009)(1800799012)(451199024)(31686004)(41300700001)(38100700002)(2906002)(7416002)(30864003)(316002)(36756003)(5660300002)(4326008)(8676002)(8936002)(2616005)(6486002)(6512007)(26005)(53546011)(6506007)(478600001)(31696002)(66946007)(66476007)(66556008)(83380400001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dFAxVjRsREdtL0ZpczNQWDU3N1lEZXJybEFVdnVXMXVseFBUSEMrcU8xTTdW?=
 =?utf-8?B?Zm1KbkFsVXpyUm9VMDltcC94QW5ERWNoNEhtTDZMcldxQjdPQ2dJbkc4QnNw?=
 =?utf-8?B?bDduMTNEWmtOblFWTkVjc0VwQTVtWHB2ODE5NlVyUW9rcWtCdnZCbE84dXpp?=
 =?utf-8?B?WGwwUXBDUWsxeDV4bVB1a3BrbE44TUpUemJDYTdNWDYwZXNPb08xMEgrKzFH?=
 =?utf-8?B?WkVpZFpqdWNONlF4ajRhVlhRMmQyMVpKbkxnZ0xmVnJPL0FxK3RUSGZTRnUr?=
 =?utf-8?B?d2s5dm4rQWVWdWdmVS8xYzd4ZC9jYm9sVjhjTERHUTU1VDJBeGFvRGxTTlFM?=
 =?utf-8?B?cm8rZ3dyb2VSNTBnQUhqaDNBUnhWV21JTUxoVjNJdExNdFpnUjh6QU44b2tt?=
 =?utf-8?B?bFZpS2xIbDJmN0JsaFN6UVphbXUvV3UwdEpXbkN3aS9saVZGSm8zdG81ekVp?=
 =?utf-8?B?a210em5YbzFOYVAyeVNDYW5yVDJ0d0Q2U2FXUVJZaC9KejBNZFF2THFYMjJF?=
 =?utf-8?B?TllCZ3RFN1EzSWVkMlJvTnMwNlphQitYTG1WSit2Q3BZQmx4TExDN0g4TzR3?=
 =?utf-8?B?OGZrZTY5b1IzRDRsbHJWblVTY2trc2JRRnp6bDBEak9tTHBIT2Z6M2NrL1V2?=
 =?utf-8?B?L1BhTmhTN2RldjNHU09GeG5LSitxTUIrQ0VwdVFKQ080TVV6aXRCZG1rQ1BN?=
 =?utf-8?B?R1VSYzd5SzFuRjFDcGpiOTBXMlR2dmhhR0ltZkVMMnFwMDBCRkpZdWRzb1Mx?=
 =?utf-8?B?bGxVaklYYm1KNFVwdWE2OGc5Zi9LYlFqUVR4Q3czeDlROElTMkFzQlhoVnpn?=
 =?utf-8?B?aFV3enllTFhCUXB0UFFoRkVpVkhwZ0IvZUtXcjRRS2hGK0NVR1dsNkFXTXZV?=
 =?utf-8?B?RHNYdUV3NkJQdzViQnU0STZJSHNOVTNpTVNvK3RvTVVIV3drTUYwdG5xVHha?=
 =?utf-8?B?Sytsb1R1R1k4Yy9Galo5T2FDUlJyUHNYRjNIdW9SVnhhU05CY28rOEUwUEFJ?=
 =?utf-8?B?SHF2UHB2MXZXS1krVVc1Q2d4WTB3bkk3MTQ4N1ZBV3dpMmhKZC91Mlk3c3ZX?=
 =?utf-8?B?SnRUMmxrMjFQMWFsWW12enRDQkdDOVh1Y0hNbHJQMzhQc3ZiendNN2VBemlN?=
 =?utf-8?B?alA1WkFGRGgzVDFWbDd6SU1YVVpmdVBSL3JSdWdrMFUvZTQxZWZZSCtacnVY?=
 =?utf-8?B?aEUrWitsRjNEcEh0TUpFaHliVi92Z1gralIwOE9oWTJtbkY5a2wyWnE4MElJ?=
 =?utf-8?B?WGVTZzNRdjlCOUg2dUxyb2hKYXhLcEUrMmZPV1hJbmdCS3pDbUVxcXUvVlYv?=
 =?utf-8?B?TE9kaU1teU1OMVU5eGNqaTFRWUFjV3RuMGhiY1RjaGU3TDJuSVdPQWM5U045?=
 =?utf-8?B?NlhpbktjTHBDZXJsN0kwKzlXcE42b2lDS3FZK21YMk1aNS9VcFhVbnc2WFNQ?=
 =?utf-8?B?NmlXOU5PM0x1eHU1bjBWd3F0WXIzR1AvNktoaVZHd3ZpT1RlaW5EWXRUYWlX?=
 =?utf-8?B?RTk3ZVJSb2xoRE1NbUV0TkwyT09WOWJSM1FtekxCeVpCbThmZ25sa1dlVFEr?=
 =?utf-8?B?UzJZS2FWQ2ZYNm1QNUJ4Zi8xWnFLUVVpMUc5Zk5KMjgxdUtiVG9PbjY3NmxL?=
 =?utf-8?B?UFo3ZTJrY3NpUGFHeGZVU2pKZ0J2YlQrcjQ5ak9nYWdPeGVMSG5OdXpvSVh2?=
 =?utf-8?B?dTlNTHQzRUR2T011Qm5zY2JsTGcxeEtoaUQ5cVlDbm1aNm53ZU5vc1JUMkU1?=
 =?utf-8?B?UnBCVEh2eThMWW55U1B1VUc0ZDczVlQ2NzJ6dXdJeHhrbXh5TnRZcGNZamZ4?=
 =?utf-8?B?eUhOQm83eWJCdnV0bDErVzRqc0NRZ3htMXVxek82N2NrdVQ5bHZHOWxneDZu?=
 =?utf-8?B?L2s2Q1pBOVNxLytaQTM5cVJvMHBUQ1ljOFNQdHJZUURVVFBmT1RmWDRDWWRN?=
 =?utf-8?B?TDNWZXhWODJiOUVRZk4vSzJSMTFabXE3SEExdXpwSVBUTVEyazIzcjJxSnVl?=
 =?utf-8?B?M1VjSU1sbW5ncVpRMnd1eWV0NTVmT0hORjdGMDBpZVIxYjd3TEhhOUUzQkZ3?=
 =?utf-8?B?Z2xoTldzSHcrR0RhV3lCMjhvWXduWVEyL3BGVWNyQjA2Rk9HcGc4TDlEeVln?=
 =?utf-8?Q?fdAeuG9TjyYLF3JiEA5pWUA7J?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a577b004-e4c3-4b1b-3c08-08dbf83d0c31
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB7982.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Dec 2023 22:28:48.5566
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: V6DvaRejk0XedktVPelr24x2YoljBiqdHXsVbfsDJbDmqm7xNeiwuJiIbWQRcUmEU547Rt5yw8NmmzyKPcN85w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8647

On 11/20/2023 6:51 PM, Yahui Cao wrote:
> Caution: This message originated from an External Source. Use proper caution when opening attachments, clicking links, or responding.
> 
> 
> From: Lingyu Liu <lingyu.liu@intel.com>
> 
> During migration device resume stage, part of device state is loaded by
> replaying logged virtual channel message. By default, once virtual
> channel message is processed successfully, PF will send message to VF.
> 
> In addition, PF will notify VF about link state while handling virtual
> channel message GET_VF_RESOURCE and ENABLE_QUEUES. And VF driver will
> print link state change info once receiving notification from PF.
> 
> However, device resume stage does not need PF to send messages to VF
> for the above cases. Stop PF from sending messages to VF while VF is
> in replay state.
> 
> Signed-off-by: Lingyu Liu <lingyu.liu@intel.com>
> Signed-off-by: Yahui Cao <yahui.cao@intel.com>
> ---
>   drivers/net/ethernet/intel/ice/ice_vf_lib.h   |   1 +
>   drivers/net/ethernet/intel/ice/ice_virtchnl.c | 179 +++++++++++-------
>   drivers/net/ethernet/intel/ice/ice_virtchnl.h |   8 +-
>   .../ethernet/intel/ice/ice_virtchnl_fdir.c    |  28 +--
>   4 files changed, 127 insertions(+), 89 deletions(-)
> 
> diff --git a/drivers/net/ethernet/intel/ice/ice_vf_lib.h b/drivers/net/ethernet/intel/ice/ice_vf_lib.h
> index 93c774f2f437..c7e7df7baf38 100644
> --- a/drivers/net/ethernet/intel/ice/ice_vf_lib.h
> +++ b/drivers/net/ethernet/intel/ice/ice_vf_lib.h
> @@ -37,6 +37,7 @@ enum ice_vf_states {
>          ICE_VF_STATE_DIS,
>          ICE_VF_STATE_MC_PROMISC,
>          ICE_VF_STATE_UC_PROMISC,
> +       ICE_VF_STATE_REPLAYING_VC,

Should this enum have "MIGRATION" in it to make it clear that this flag 
is specifically for replaying VF state for migration purposes?

>          ICE_VF_STATES_NBITS
>   };
> 
> diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl.c b/drivers/net/ethernet/intel/ice/ice_virtchnl.c
> index cdf17b1e2f25..661ca86c3032 100644
> --- a/drivers/net/ethernet/intel/ice/ice_virtchnl.c
> +++ b/drivers/net/ethernet/intel/ice/ice_virtchnl.c
> @@ -233,6 +233,9 @@ void ice_vc_notify_vf_link_state(struct ice_vf *vf)
>          struct virtchnl_pf_event pfe = { 0 };
>          struct ice_hw *hw = &vf->pf->hw;
> 
> +       if (test_bit(ICE_VF_STATE_REPLAYING_VC, vf->vf_states))
> +               return;
> +
>          pfe.event = VIRTCHNL_EVENT_LINK_CHANGE;
>          pfe.severity = PF_EVENT_SEVERITY_INFO;
> 
> @@ -282,7 +285,7 @@ void ice_vc_notify_reset(struct ice_pf *pf)
>   }
> 
>   /**
> - * ice_vc_send_msg_to_vf - Send message to VF
> + * ice_vc_send_response_to_vf - Send response message to VF
>    * @vf: pointer to the VF info
>    * @v_opcode: virtual channel opcode
>    * @v_retval: virtual channel return value
> @@ -291,9 +294,10 @@ void ice_vc_notify_reset(struct ice_pf *pf)
>    *
>    * send msg to VF
>    */
> -int
> -ice_vc_send_msg_to_vf(struct ice_vf *vf, u32 v_opcode,
> -                     enum virtchnl_status_code v_retval, u8 *msg, u16 msglen)
> +static int
> +ice_vc_send_response_to_vf(struct ice_vf *vf, u32 v_opcode,
> +                          enum virtchnl_status_code v_retval,
> +                          u8 *msg, u16 msglen)

Is all of this rework needed? It seems like it's just a name change with 
additional logic to check the REPLAYING state. IMHO the naming isn't 
really any cleaner.

Would it make more sense to just modify the current 
ice_vc_send_msg_to_vf() to handle the REPLAYING state? It seems like 
that would simplify this patch quite a bit.

Is there a reason for these changes in follow up patches that I missed?

Thanks,

Brett
>   {
>          struct device *dev;
>          struct ice_pf *pf;
> @@ -314,6 +318,39 @@ ice_vc_send_msg_to_vf(struct ice_vf *vf, u32 v_opcode,
>          return 0;
>   }
> 
> +/**
> + * ice_vc_respond_to_vf - Respond to VF
> + * @vf: pointer to the VF info
> + * @v_opcode: virtual channel opcode
> + * @v_retval: virtual channel return value
> + * @msg: pointer to the msg buffer
> + * @msglen: msg length
> + *
> + * Respond to VF. If it is replaying, return directly.
> + *
> + * Return 0 for success, negative for error.
> + */
> +int
> +ice_vc_respond_to_vf(struct ice_vf *vf, u32 v_opcode,
> +                    enum virtchnl_status_code v_retval, u8 *msg, u16 msglen)
> +{
> +       struct device *dev;
> +       struct ice_pf *pf = vf->pf;
> +
> +       dev = ice_pf_to_dev(pf);
> +
> +       if (test_bit(ICE_VF_STATE_REPLAYING_VC, vf->vf_states)) {
> +               if (v_retval == VIRTCHNL_STATUS_SUCCESS)
> +                       return 0;
> +
> +               dev_dbg(dev, "Unable to replay virt channel command, VF ID %d, virtchnl status code %d. op code %d, len %d.\n",
> +                       vf->vf_id, v_retval, v_opcode, msglen);
> +               return -EIO;
> +       }
> +
> +       return ice_vc_send_response_to_vf(vf, v_opcode, v_retval, msg, msglen);
> +}
> +
>   /**
>    * ice_vc_get_ver_msg
>    * @vf: pointer to the VF info
> @@ -332,9 +369,9 @@ static int ice_vc_get_ver_msg(struct ice_vf *vf, u8 *msg)
>          if (VF_IS_V10(&vf->vf_ver))
>                  info.minor = VIRTCHNL_VERSION_MINOR_NO_VF_CAPS;
> 
> -       return ice_vc_send_msg_to_vf(vf, VIRTCHNL_OP_VERSION,
> -                                    VIRTCHNL_STATUS_SUCCESS, (u8 *)&info,
> -                                    sizeof(struct virtchnl_version_info));
> +       return ice_vc_respond_to_vf(vf, VIRTCHNL_OP_VERSION,
> +                                   VIRTCHNL_STATUS_SUCCESS, (u8 *)&info,
> +                                   sizeof(struct virtchnl_version_info));
>   }
> 
>   /**
> @@ -522,8 +559,8 @@ static int ice_vc_get_vf_res_msg(struct ice_vf *vf, u8 *msg)
> 
>   err:
>          /* send the response back to the VF */
> -       ret = ice_vc_send_msg_to_vf(vf, VIRTCHNL_OP_GET_VF_RESOURCES, v_ret,
> -                                   (u8 *)vfres, len);
> +       ret = ice_vc_respond_to_vf(vf, VIRTCHNL_OP_GET_VF_RESOURCES, v_ret,
> +                                  (u8 *)vfres, len);
> 
>          kfree(vfres);
>          return ret;
> @@ -892,7 +929,7 @@ static int ice_vc_handle_rss_cfg(struct ice_vf *vf, u8 *msg, bool add)
>          }
> 
>   error_param:
> -       return ice_vc_send_msg_to_vf(vf, v_opcode, v_ret, NULL, 0);
> +       return ice_vc_respond_to_vf(vf, v_opcode, v_ret, NULL, 0);
>   }
> 
>   /**
> @@ -938,8 +975,8 @@ static int ice_vc_config_rss_key(struct ice_vf *vf, u8 *msg)
>          if (ice_set_rss_key(vsi, vrk->key))
>                  v_ret = VIRTCHNL_STATUS_ERR_ADMIN_QUEUE_ERROR;
>   error_param:
> -       return ice_vc_send_msg_to_vf(vf, VIRTCHNL_OP_CONFIG_RSS_KEY, v_ret,
> -                                    NULL, 0);
> +       return ice_vc_respond_to_vf(vf, VIRTCHNL_OP_CONFIG_RSS_KEY, v_ret,
> +                                   NULL, 0);
>   }
> 
>   /**
> @@ -984,7 +1021,7 @@ static int ice_vc_config_rss_lut(struct ice_vf *vf, u8 *msg)
>          if (ice_set_rss_lut(vsi, vrl->lut, ICE_LUT_VSI_SIZE))
>                  v_ret = VIRTCHNL_STATUS_ERR_ADMIN_QUEUE_ERROR;
>   error_param:
> -       return ice_vc_send_msg_to_vf(vf, VIRTCHNL_OP_CONFIG_RSS_LUT, v_ret,
> +       return ice_vc_respond_to_vf(vf, VIRTCHNL_OP_CONFIG_RSS_LUT, v_ret,
>                                       NULL, 0);
>   }
> 
> @@ -1124,8 +1161,8 @@ static int ice_vc_cfg_promiscuous_mode_msg(struct ice_vf *vf, u8 *msg)
>          }
> 
>   error_param:
> -       return ice_vc_send_msg_to_vf(vf, VIRTCHNL_OP_CONFIG_PROMISCUOUS_MODE,
> -                                    v_ret, NULL, 0);
> +       return ice_vc_respond_to_vf(vf, VIRTCHNL_OP_CONFIG_PROMISCUOUS_MODE,
> +                                   v_ret, NULL, 0);
>   }
> 
>   /**
> @@ -1165,8 +1202,8 @@ static int ice_vc_get_stats_msg(struct ice_vf *vf, u8 *msg)
> 
>   error_param:
>          /* send the response to the VF */
> -       return ice_vc_send_msg_to_vf(vf, VIRTCHNL_OP_GET_STATS, v_ret,
> -                                    (u8 *)&stats, sizeof(stats));
> +       return ice_vc_respond_to_vf(vf, VIRTCHNL_OP_GET_STATS, v_ret,
> +                                   (u8 *)&stats, sizeof(stats));
>   }
> 
>   /**
> @@ -1315,8 +1352,8 @@ static int ice_vc_ena_qs_msg(struct ice_vf *vf, u8 *msg)
> 
>   error_param:
>          /* send the response to the VF */
> -       return ice_vc_send_msg_to_vf(vf, VIRTCHNL_OP_ENABLE_QUEUES, v_ret,
> -                                    NULL, 0);
> +       return ice_vc_respond_to_vf(vf, VIRTCHNL_OP_ENABLE_QUEUES, v_ret,
> +                                   NULL, 0);
>   }
> 
>   /**
> @@ -1455,8 +1492,8 @@ static int ice_vc_dis_qs_msg(struct ice_vf *vf, u8 *msg)
> 
>   error_param:
>          /* send the response to the VF */
> -       return ice_vc_send_msg_to_vf(vf, VIRTCHNL_OP_DISABLE_QUEUES, v_ret,
> -                                    NULL, 0);
> +       return ice_vc_respond_to_vf(vf, VIRTCHNL_OP_DISABLE_QUEUES, v_ret,
> +                                   NULL, 0);
>   }
> 
>   /**
> @@ -1586,8 +1623,8 @@ static int ice_vc_cfg_irq_map_msg(struct ice_vf *vf, u8 *msg)
> 
>   error_param:
>          /* send the response to the VF */
> -       return ice_vc_send_msg_to_vf(vf, VIRTCHNL_OP_CONFIG_IRQ_MAP, v_ret,
> -                                    NULL, 0);
> +       return ice_vc_respond_to_vf(vf, VIRTCHNL_OP_CONFIG_IRQ_MAP, v_ret,
> +                                   NULL, 0);
>   }
> 
>   /**
> @@ -1730,8 +1767,8 @@ static int ice_vc_cfg_qs_msg(struct ice_vf *vf, u8 *msg)
>          }
> 
>          /* send the response to the VF */
> -       return ice_vc_send_msg_to_vf(vf, VIRTCHNL_OP_CONFIG_VSI_QUEUES,
> -                                    VIRTCHNL_STATUS_SUCCESS, NULL, 0);
> +       return ice_vc_respond_to_vf(vf, VIRTCHNL_OP_CONFIG_VSI_QUEUES,
> +                                   VIRTCHNL_STATUS_SUCCESS, NULL, 0);
>   error_param:
>          /* disable whatever we can */
>          for (; i >= 0; i--) {
> @@ -1746,8 +1783,8 @@ static int ice_vc_cfg_qs_msg(struct ice_vf *vf, u8 *msg)
>          ice_lag_move_new_vf_nodes(vf);
> 
>          /* send the response to the VF */
> -       return ice_vc_send_msg_to_vf(vf, VIRTCHNL_OP_CONFIG_VSI_QUEUES,
> -                                    VIRTCHNL_STATUS_ERR_PARAM, NULL, 0);
> +       return ice_vc_respond_to_vf(vf, VIRTCHNL_OP_CONFIG_VSI_QUEUES,
> +                                   VIRTCHNL_STATUS_ERR_PARAM, NULL, 0);
>   }
> 
>   /**
> @@ -2049,7 +2086,7 @@ ice_vc_handle_mac_addr_msg(struct ice_vf *vf, u8 *msg, bool set)
> 
>   handle_mac_exit:
>          /* send the response to the VF */
> -       return ice_vc_send_msg_to_vf(vf, vc_op, v_ret, NULL, 0);
> +       return ice_vc_respond_to_vf(vf, vc_op, v_ret, NULL, 0);
>   }
> 
>   /**
> @@ -2132,8 +2169,8 @@ static int ice_vc_request_qs_msg(struct ice_vf *vf, u8 *msg)
> 
>   error_param:
>          /* send the response to the VF */
> -       return ice_vc_send_msg_to_vf(vf, VIRTCHNL_OP_REQUEST_QUEUES,
> -                                    v_ret, (u8 *)vfres, sizeof(*vfres));
> +       return ice_vc_respond_to_vf(vf, VIRTCHNL_OP_REQUEST_QUEUES,
> +                                   v_ret, (u8 *)vfres, sizeof(*vfres));
>   }
> 
>   /**
> @@ -2398,11 +2435,11 @@ static int ice_vc_process_vlan_msg(struct ice_vf *vf, u8 *msg, bool add_v)
>   error_param:
>          /* send the response to the VF */
>          if (add_v)
> -               return ice_vc_send_msg_to_vf(vf, VIRTCHNL_OP_ADD_VLAN, v_ret,
> -                                            NULL, 0);
> +               return ice_vc_respond_to_vf(vf, VIRTCHNL_OP_ADD_VLAN, v_ret,
> +                                           NULL, 0);
>          else
> -               return ice_vc_send_msg_to_vf(vf, VIRTCHNL_OP_DEL_VLAN, v_ret,
> -                                            NULL, 0);
> +               return ice_vc_respond_to_vf(vf, VIRTCHNL_OP_DEL_VLAN, v_ret,
> +                                           NULL, 0);
>   }
> 
>   /**
> @@ -2477,8 +2514,8 @@ static int ice_vc_ena_vlan_stripping(struct ice_vf *vf)
>                  vf->vlan_strip_ena |= ICE_INNER_VLAN_STRIP_ENA;
> 
>   error_param:
> -       return ice_vc_send_msg_to_vf(vf, VIRTCHNL_OP_ENABLE_VLAN_STRIPPING,
> -                                    v_ret, NULL, 0);
> +       return ice_vc_respond_to_vf(vf, VIRTCHNL_OP_ENABLE_VLAN_STRIPPING,
> +                                   v_ret, NULL, 0);
>   }
> 
>   /**
> @@ -2514,8 +2551,8 @@ static int ice_vc_dis_vlan_stripping(struct ice_vf *vf)
>                  vf->vlan_strip_ena &= ~ICE_INNER_VLAN_STRIP_ENA;
> 
>   error_param:
> -       return ice_vc_send_msg_to_vf(vf, VIRTCHNL_OP_DISABLE_VLAN_STRIPPING,
> -                                    v_ret, NULL, 0);
> +       return ice_vc_respond_to_vf(vf, VIRTCHNL_OP_DISABLE_VLAN_STRIPPING,
> +                                   v_ret, NULL, 0);
>   }
> 
>   /**
> @@ -2550,8 +2587,8 @@ static int ice_vc_get_rss_hena(struct ice_vf *vf)
>          vrh->hena = ICE_DEFAULT_RSS_HENA;
>   err:
>          /* send the response back to the VF */
> -       ret = ice_vc_send_msg_to_vf(vf, VIRTCHNL_OP_GET_RSS_HENA_CAPS, v_ret,
> -                                   (u8 *)vrh, len);
> +       ret = ice_vc_respond_to_vf(vf, VIRTCHNL_OP_GET_RSS_HENA_CAPS, v_ret,
> +                                  (u8 *)vrh, len);
>          kfree(vrh);
>          return ret;
>   }
> @@ -2616,8 +2653,8 @@ static int ice_vc_set_rss_hena(struct ice_vf *vf, u8 *msg)
> 
>          /* send the response to the VF */
>   err:
> -       return ice_vc_send_msg_to_vf(vf, VIRTCHNL_OP_SET_RSS_HENA, v_ret,
> -                                    NULL, 0);
> +       return ice_vc_respond_to_vf(vf, VIRTCHNL_OP_SET_RSS_HENA, v_ret,
> +                                   NULL, 0);
>   }
> 
>   /**
> @@ -2672,8 +2709,8 @@ static int ice_vc_query_rxdid(struct ice_vf *vf)
>          pf->supported_rxdids = rxdid->supported_rxdids;
> 
>   err:
> -       ret = ice_vc_send_msg_to_vf(vf, VIRTCHNL_OP_GET_SUPPORTED_RXDIDS,
> -                                   v_ret, (u8 *)rxdid, len);
> +       ret = ice_vc_respond_to_vf(vf, VIRTCHNL_OP_GET_SUPPORTED_RXDIDS,
> +                                  v_ret, (u8 *)rxdid, len);
>          kfree(rxdid);
>          return ret;
>   }
> @@ -2909,8 +2946,8 @@ static int ice_vc_get_offload_vlan_v2_caps(struct ice_vf *vf)
>          memcpy(&vf->vlan_v2_caps, caps, sizeof(*caps));
> 
>   out:
> -       err = ice_vc_send_msg_to_vf(vf, VIRTCHNL_OP_GET_OFFLOAD_VLAN_V2_CAPS,
> -                                   v_ret, (u8 *)caps, len);
> +       err = ice_vc_respond_to_vf(vf, VIRTCHNL_OP_GET_OFFLOAD_VLAN_V2_CAPS,
> +                                  v_ret, (u8 *)caps, len);
>          kfree(caps);
>          return err;
>   }
> @@ -3151,8 +3188,8 @@ static int ice_vc_remove_vlan_v2_msg(struct ice_vf *vf, u8 *msg)
>                  v_ret = VIRTCHNL_STATUS_ERR_PARAM;
> 
>   out:
> -       return ice_vc_send_msg_to_vf(vf, VIRTCHNL_OP_DEL_VLAN_V2, v_ret, NULL,
> -                                    0);
> +       return ice_vc_respond_to_vf(vf, VIRTCHNL_OP_DEL_VLAN_V2,
> +                                   v_ret, NULL, 0);
>   }
> 
>   /**
> @@ -3293,8 +3330,8 @@ static int ice_vc_add_vlan_v2_msg(struct ice_vf *vf, u8 *msg)
>                  v_ret = VIRTCHNL_STATUS_ERR_PARAM;
> 
>   out:
> -       return ice_vc_send_msg_to_vf(vf, VIRTCHNL_OP_ADD_VLAN_V2, v_ret, NULL,
> -                                    0);
> +       return ice_vc_respond_to_vf(vf, VIRTCHNL_OP_ADD_VLAN_V2,
> +                                   v_ret, NULL, 0);
>   }
> 
>   /**
> @@ -3525,8 +3562,8 @@ static int ice_vc_ena_vlan_stripping_v2_msg(struct ice_vf *vf, u8 *msg)
>                  vf->vlan_strip_ena |= ICE_INNER_VLAN_STRIP_ENA;
> 
>   out:
> -       return ice_vc_send_msg_to_vf(vf, VIRTCHNL_OP_ENABLE_VLAN_STRIPPING_V2,
> -                                    v_ret, NULL, 0);
> +       return ice_vc_respond_to_vf(vf, VIRTCHNL_OP_ENABLE_VLAN_STRIPPING_V2,
> +                                   v_ret, NULL, 0);
>   }
> 
>   /**
> @@ -3600,8 +3637,8 @@ static int ice_vc_dis_vlan_stripping_v2_msg(struct ice_vf *vf, u8 *msg)
>                  vf->vlan_strip_ena &= ~ICE_INNER_VLAN_STRIP_ENA;
> 
>   out:
> -       return ice_vc_send_msg_to_vf(vf, VIRTCHNL_OP_DISABLE_VLAN_STRIPPING_V2,
> -                                    v_ret, NULL, 0);
> +       return ice_vc_respond_to_vf(vf, VIRTCHNL_OP_DISABLE_VLAN_STRIPPING_V2,
> +                                   v_ret, NULL, 0);
>   }
> 
>   /**
> @@ -3659,8 +3696,8 @@ static int ice_vc_ena_vlan_insertion_v2_msg(struct ice_vf *vf, u8 *msg)
>          }
> 
>   out:
> -       return ice_vc_send_msg_to_vf(vf, VIRTCHNL_OP_ENABLE_VLAN_INSERTION_V2,
> -                                    v_ret, NULL, 0);
> +       return ice_vc_respond_to_vf(vf, VIRTCHNL_OP_ENABLE_VLAN_INSERTION_V2,
> +                                   v_ret, NULL, 0);
>   }
> 
>   /**
> @@ -3714,8 +3751,8 @@ static int ice_vc_dis_vlan_insertion_v2_msg(struct ice_vf *vf, u8 *msg)
>          }
> 
>   out:
> -       return ice_vc_send_msg_to_vf(vf, VIRTCHNL_OP_DISABLE_VLAN_INSERTION_V2,
> -                                    v_ret, NULL, 0);
> +       return ice_vc_respond_to_vf(vf, VIRTCHNL_OP_DISABLE_VLAN_INSERTION_V2,
> +                                   v_ret, NULL, 0);
>   }
> 
>   static const struct ice_virtchnl_ops ice_virtchnl_dflt_ops = {
> @@ -3812,8 +3849,8 @@ static int ice_vc_repr_add_mac(struct ice_vf *vf, u8 *msg)
>          }
> 
>   handle_mac_exit:
> -       return ice_vc_send_msg_to_vf(vf, VIRTCHNL_OP_ADD_ETH_ADDR,
> -                                    v_ret, NULL, 0);
> +       return ice_vc_respond_to_vf(vf, VIRTCHNL_OP_ADD_ETH_ADDR,
> +                                   v_ret, NULL, 0);
>   }
> 
>   /**
> @@ -3832,8 +3869,8 @@ ice_vc_repr_del_mac(struct ice_vf __always_unused *vf, u8 __always_unused *msg)
> 
>          ice_update_legacy_cached_mac(vf, &al->list[0]);
> 
> -       return ice_vc_send_msg_to_vf(vf, VIRTCHNL_OP_DEL_ETH_ADDR,
> -                                    VIRTCHNL_STATUS_SUCCESS, NULL, 0);
> +       return ice_vc_respond_to_vf(vf, VIRTCHNL_OP_DEL_ETH_ADDR,
> +                                   VIRTCHNL_STATUS_SUCCESS, NULL, 0);
>   }
> 
>   static int
> @@ -3842,8 +3879,8 @@ ice_vc_repr_cfg_promiscuous_mode(struct ice_vf *vf, u8 __always_unused *msg)
>          dev_dbg(ice_pf_to_dev(vf->pf),
>                  "Can't config promiscuous mode in switchdev mode for VF %d\n",
>                  vf->vf_id);
> -       return ice_vc_send_msg_to_vf(vf, VIRTCHNL_OP_CONFIG_PROMISCUOUS_MODE,
> -                                    VIRTCHNL_STATUS_ERR_NOT_SUPPORTED,
> +       return ice_vc_respond_to_vf(vf, VIRTCHNL_OP_CONFIG_PROMISCUOUS_MODE,
> +                                   VIRTCHNL_STATUS_ERR_NOT_SUPPORTED,
>                                       NULL, 0);
>   }
> 
> @@ -3986,16 +4023,16 @@ void ice_vc_process_vf_msg(struct ice_pf *pf, struct ice_rq_event_info *event,
> 
>   error_handler:
>          if (err) {
> -               ice_vc_send_msg_to_vf(vf, v_opcode, VIRTCHNL_STATUS_ERR_PARAM,
> -                                     NULL, 0);
> +               ice_vc_respond_to_vf(vf, v_opcode, VIRTCHNL_STATUS_ERR_PARAM,
> +                                    NULL, 0);
>                  dev_err(dev, "Invalid message from VF %d, opcode %d, len %d, error %d\n",
>                          vf_id, v_opcode, msglen, err);
>                  goto finish;
>          }
> 
>          if (!ice_vc_is_opcode_allowed(vf, v_opcode)) {
> -               ice_vc_send_msg_to_vf(vf, v_opcode,
> -                                     VIRTCHNL_STATUS_ERR_NOT_SUPPORTED, NULL,
> +               ice_vc_respond_to_vf(vf, v_opcode,
> +                                    VIRTCHNL_STATUS_ERR_NOT_SUPPORTED, NULL,
>                                        0);
>                  goto finish;
>          }
> @@ -4106,9 +4143,9 @@ void ice_vc_process_vf_msg(struct ice_pf *pf, struct ice_rq_event_info *event,
>          default:
>                  dev_err(dev, "Unsupported opcode %d from VF %d\n", v_opcode,
>                          vf_id);
> -               err = ice_vc_send_msg_to_vf(vf, v_opcode,
> -                                           VIRTCHNL_STATUS_ERR_NOT_SUPPORTED,
> -                                           NULL, 0);
> +               err = ice_vc_respond_to_vf(vf, v_opcode,
> +                                          VIRTCHNL_STATUS_ERR_NOT_SUPPORTED,
> +                                          NULL, 0);
>                  break;
>          }
>          if (err) {
> diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl.h b/drivers/net/ethernet/intel/ice/ice_virtchnl.h
> index cd747718de73..a2b6094e2f2f 100644
> --- a/drivers/net/ethernet/intel/ice/ice_virtchnl.h
> +++ b/drivers/net/ethernet/intel/ice/ice_virtchnl.h
> @@ -60,8 +60,8 @@ void ice_vc_notify_vf_link_state(struct ice_vf *vf);
>   void ice_vc_notify_link_state(struct ice_pf *pf);
>   void ice_vc_notify_reset(struct ice_pf *pf);
>   int
> -ice_vc_send_msg_to_vf(struct ice_vf *vf, u32 v_opcode,
> -                     enum virtchnl_status_code v_retval, u8 *msg, u16 msglen);
> +ice_vc_respond_to_vf(struct ice_vf *vf, u32 v_opcode,
> +                    enum virtchnl_status_code v_retval, u8 *msg, u16 msglen);
>   bool ice_vc_isvalid_vsi_id(struct ice_vf *vf, u16 vsi_id);
>   void ice_vc_process_vf_msg(struct ice_pf *pf, struct ice_rq_event_info *event,
>                             struct ice_mbx_data *mbxdata);
> @@ -73,8 +73,8 @@ static inline void ice_vc_notify_link_state(struct ice_pf *pf) { }
>   static inline void ice_vc_notify_reset(struct ice_pf *pf) { }
> 
>   static inline int
> -ice_vc_send_msg_to_vf(struct ice_vf *vf, u32 v_opcode,
> -                     enum virtchnl_status_code v_retval, u8 *msg, u16 msglen)
> +ice_vc_respond_to_vf(struct ice_vf *vf, u32 v_opcode,
> +                    enum virtchnl_status_code v_retval, u8 *msg, u16 msglen)
>   {
>          return -EOPNOTSUPP;
>   }
> diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl_fdir.c b/drivers/net/ethernet/intel/ice/ice_virtchnl_fdir.c
> index 24b23b7ef04a..816d8bf8bec4 100644
> --- a/drivers/net/ethernet/intel/ice/ice_virtchnl_fdir.c
> +++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_fdir.c
> @@ -1584,8 +1584,8 @@ ice_vc_add_fdir_fltr_post(struct ice_vf *vf, struct ice_vf_fdir_ctx *ctx,
>          resp->flow_id = conf->flow_id;
>          vf->fdir.fdir_fltr_cnt[conf->input.flow_type][is_tun]++;
> 
> -       ret = ice_vc_send_msg_to_vf(vf, ctx->v_opcode, v_ret,
> -                                   (u8 *)resp, len);
> +       ret = ice_vc_respond_to_vf(vf, ctx->v_opcode, v_ret,
> +                                  (u8 *)resp, len);
>          kfree(resp);
> 
>          dev_dbg(dev, "VF %d: flow_id:0x%X, FDIR %s success!\n",
> @@ -1600,8 +1600,8 @@ ice_vc_add_fdir_fltr_post(struct ice_vf *vf, struct ice_vf_fdir_ctx *ctx,
>          ice_vc_fdir_remove_entry(vf, conf, conf->flow_id);
>          devm_kfree(dev, conf);
> 
> -       ret = ice_vc_send_msg_to_vf(vf, ctx->v_opcode, v_ret,
> -                                   (u8 *)resp, len);
> +       ret = ice_vc_respond_to_vf(vf, ctx->v_opcode, v_ret,
> +                                  (u8 *)resp, len);
>          kfree(resp);
>          return ret;
>   }
> @@ -1648,8 +1648,8 @@ ice_vc_del_fdir_fltr_post(struct ice_vf *vf, struct ice_vf_fdir_ctx *ctx,
>          ice_vc_fdir_remove_entry(vf, conf, conf->flow_id);
>          vf->fdir.fdir_fltr_cnt[conf->input.flow_type][is_tun]--;
> 
> -       ret = ice_vc_send_msg_to_vf(vf, ctx->v_opcode, v_ret,
> -                                   (u8 *)resp, len);
> +       ret = ice_vc_respond_to_vf(vf, ctx->v_opcode, v_ret,
> +                                  (u8 *)resp, len);
>          kfree(resp);
> 
>          dev_dbg(dev, "VF %d: flow_id:0x%X, FDIR %s success!\n",
> @@ -1665,8 +1665,8 @@ ice_vc_del_fdir_fltr_post(struct ice_vf *vf, struct ice_vf_fdir_ctx *ctx,
>          if (success)
>                  devm_kfree(dev, conf);
> 
> -       ret = ice_vc_send_msg_to_vf(vf, ctx->v_opcode, v_ret,
> -                                   (u8 *)resp, len);
> +       ret = ice_vc_respond_to_vf(vf, ctx->v_opcode, v_ret,
> +                                  (u8 *)resp, len);
>          kfree(resp);
>          return ret;
>   }
> @@ -1863,8 +1863,8 @@ int ice_vc_add_fdir_fltr(struct ice_vf *vf, u8 *msg)
>                  v_ret = VIRTCHNL_STATUS_SUCCESS;
>                  stat->status = VIRTCHNL_FDIR_SUCCESS;
>                  devm_kfree(dev, conf);
> -               ret = ice_vc_send_msg_to_vf(vf, VIRTCHNL_OP_ADD_FDIR_FILTER,
> -                                           v_ret, (u8 *)stat, len);
> +               ret = ice_vc_respond_to_vf(vf, VIRTCHNL_OP_ADD_FDIR_FILTER,
> +                                          v_ret, (u8 *)stat, len);
>                  goto exit;
>          }
> 
> @@ -1922,8 +1922,8 @@ int ice_vc_add_fdir_fltr(struct ice_vf *vf, u8 *msg)
>   err_free_conf:
>          devm_kfree(dev, conf);
>   err_exit:
> -       ret = ice_vc_send_msg_to_vf(vf, VIRTCHNL_OP_ADD_FDIR_FILTER, v_ret,
> -                                   (u8 *)stat, len);
> +       ret = ice_vc_respond_to_vf(vf, VIRTCHNL_OP_ADD_FDIR_FILTER, v_ret,
> +                                  (u8 *)stat, len);
>          kfree(stat);
>          return ret;
>   }
> @@ -2006,8 +2006,8 @@ int ice_vc_del_fdir_fltr(struct ice_vf *vf, u8 *msg)
>   err_del_tmr:
>          ice_vc_fdir_clear_irq_ctx(vf);
>   err_exit:
> -       ret = ice_vc_send_msg_to_vf(vf, VIRTCHNL_OP_DEL_FDIR_FILTER, v_ret,
> -                                   (u8 *)stat, len);
> +       ret = ice_vc_respond_to_vf(vf, VIRTCHNL_OP_DEL_FDIR_FILTER, v_ret,
> +                                  (u8 *)stat, len);
>          kfree(stat);
>          return ret;
>   }
> --
> 2.34.1
> 

